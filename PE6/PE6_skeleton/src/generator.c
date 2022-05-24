#include "vslc.h"
#include <inttypes.h>

symbol_t* first;

#define MIN(a,b) (((a)<(b)) ? (a):(b))
static const char *record[6] = {
    "%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9"
};

static void 
translate();

int label_c = 0;

static void
generate_stringtable ( void )
{
    /* These can be used to emit numbers, strings and a run-time
     * error msg. from main
     */ 
    puts ( ".data" );
    puts ( "intout: .asciz \"\%ld \"" );
    puts ( "strout: .asciz \"\%s \"" );
    puts ( "errout: .asciz \"Wrong number of arguments\"" );

    /* TODO:  handle the strings from the program */
    for(int i = 0; i< stringc; i++){
        // For each string, output the corresponding line in the data segment
        printf( "STR%d: \t.asciz %s\n", i, string_list[i]);
    }
    // Add an empty line between the strings and the globals
    puts("");

}

static void
generate_globalvars( void )
{
  
    size_t n_globals = tlhash_size ( global_names );
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    for(int i = 0; i< n_globals; i++){
        symbol_t *glob = global_list[i];
        if(glob->type == SYM_GLOBAL_VAR){
            // If the symbol is a global variable, add the corresponding line to the
            // same data segment.
            printf("_%s: .zero 8\n", glob->name);
        } else if(glob->type == SYM_FUNCTION && glob->seq == 0){
            // At the same time, look for the first function to put into the main assembly function
            first = glob;
        }
    }
    puts("");
}

static void
get_variable_address(symbol_t* var_entry, symbol_t* func, char* buffer){
    size_t offset;
    switch (var_entry->type) {
        case SYM_GLOBAL_VAR :
            sprintf(buffer, "_%s(%%rip)", var_entry->name);
            printf("\t# address for %s (global) is %s.\n", var_entry->name, buffer);
            break;
        case SYM_LOCAL_VAR :
            ;
            size_t offset = var_entry->seq+MIN(6,func->nparms) + 1;
            sprintf(buffer, "-%zu(%%rbp)", 8*offset);
            printf("\t# address for %s (local_var_%zu) is %s because func->nparms of %s is %zu\n", var_entry->name, var_entry->seq, buffer, func->name, MIN(6, func->nparms));
            break;
        case SYM_PARAMETER :
            ;
            // if its one of the first six entries, its after the start of the stackframe, else its
            // before
            if(var_entry->seq <6){
                offset = -(var_entry->seq + 1);
            } else {
                offset = (var_entry->seq - 4);
            }
            
            // print this whole thing into the buffer
            sprintf(buffer, "%td(%%rbp)", 8*offset);
            printf("\t# address for %s (param_%zu) is %s.\n", var_entry->name, var_entry->seq, buffer);
            break;
        default :
            printf("PROBLEM");
            break;
        }
}

static void
generate_unary_expr(node_t* curr, symbol_t* func){
    switch (*(char*)(curr->data)) {
        case '-':
            // unary minus
            translate(curr->children[0]);
            printf("\tneg %%rax\n");
            break;
        case '~' :
            // unary not
            translate(curr->children[0]);
            printf("\tnot %%rax\n");
            break;
    }
    
}

static void
generate_binary_expr(node_t* curr, symbol_t* func){
    if(curr->data == NULL){
        // this is a function call
        // handle first six args
        for(int i = 0; i< MIN(6, curr->children[0]->entry->nparms); i++){
            // the first six args are put into the corresponding regs
            translate(curr->children[1]->children[i], func);
            printf("\tmovq %%rax, %s\n", record[i]);
        }
        // for the rest we go backwards and put them on the stack
        if(curr->children[0]->entry->nparms >= 6){
            for(int i = curr->children[0]->entry->nparms - 1; i>=6; i--){
                translate(curr->children[1]->children[i], func);
                printf("\tpushq %%rax\n");
            }
        }
        printf("\tcallq _%s\n", (char*)curr->children[0]->data);
        return;
    }
    // generate the right hand side, result will go into rax
    printf("\t# beginning rhs of %c expression\n", *(char*)curr->data);
    translate(curr->children[1], func);
    puts("\t# end rhs");
    // free rax by pushing on the stack
    puts("\tpushq %rax");
    // translate the second expression
    printf("\t#beginning of lhs of %c expresion\n", *(char*)curr->data);
    translate(curr->children[0], func);
    printf("\t# end of lhs\n");
    // pop the first result into r10
    puts("\tpopq %r10");
    // compute r10 op rax
    switch(*(char*)curr->data) {
        case '|':
            printf("\tor %%r10, %%rax\n");
            break;
        case '^':
            printf("\txor %%r10, %%rax\n");
            break;
        case '&':
            printf("\tand %%r10, %%rax\n");
            break;
        case '>':
            //we know this is a shift, no need to examine second char
            printf("\tmovq %%r10, %%rcx\n");
            printf("\tshr %%cl, %%rax\n");
            break;
        case '<':
            printf("\tmovq %%r10, %%rcx\n");
            printf("\tshl %%cl, %%rax\n");
            break;
        case '+':
            printf("\taddq %%r10, %%rax\n");
            break;
        case '-':
            printf("\tsubq %%r10, %%rax\n");
            break;
        case '*':
            printf("\timulq %%r10, %%rax\n");
            break;
        case '/':
            // i dont know how divisions work, but it works :/
            puts("cqto");
            printf("\tidivq %%r10\n");
            break;
    }
}

static void
translate(node_t* curr, symbol_t* func){
    if(curr == NULL) return;
    // assume no address will be longer than 100
    char address[100];
    int curr_lab;
    switch (curr->type) {
        case BLOCK :
            // simply translate the statement-list, which is either the only or the last child
            translate(curr->children[curr->n_children == 1? 0 : 1], func);
            break;
        case STATEMENT_LIST : 
            // translate each statement in succession
            for(int i = 0; i < curr->n_children; i++){
                translate(curr->children[i], func);
            }
            break;
        case ASSIGNMENT_STATEMENT :
            // translate the expression, the move it into the variable space
            printf("\t# begin assignment of %s\n", (char*)curr->children[0]->data);
            translate(curr->children[1], func);
            //puts("\tmovq $123, %rax\n");
            get_variable_address(curr->children[0]->entry, func, address);
            printf("\tmovq %%rax, %s\n", address);
            break;
        case EXPRESSION :
            if (curr->n_children == 1) {
                generate_unary_expr(curr, func);
            } else {
                generate_binary_expr(curr, func);
            }
            break;
        case NUMBER_DATA :
            ;
            // did some weird macro stuff because i thought i had an issue here
            printf("\tmovq $%" PRIu64 ", %%rax\n", *(int64_t *)curr->data);
            break;
        case IDENTIFIER_DATA :
            ;
            get_variable_address(curr->entry, func, address);
            printf("\tmovq %s, %%rax\n", address);
            break;
        case PRINT_STATEMENT :
            printf("\txor %%eax, %%eax\n");
            for(int i = 0; i < curr->n_children; i++){
               if(curr->children[i]->type == STRING_DATA){
                   // print the string literal
                   printf("\tleaq STR%zu(%%rip), %%rsi\n", *(size_t *)curr->children[i]->data);
                   printf("\tleaq strout(%%rip), %%rdi\n");
                   printf("\tcall printf\n");
               } else {
                   // otherwise, evaluate the expression and print the resulting int
                   translate(curr->children[i], func);
                   printf("\tmovq %%rax, %%rsi\n");
                   printf("\tleaq intout(%%rip), %%rdi\n");
                   printf("\tcall printf\n");
               }
                   

            }
            printf("\tmovq $'\\n', %%rdi\n");
            printf("\tcall putchar\n");
            break;
        case RETURN_STATEMENT :
            translate(curr->children[0], func);
            puts("\tleave");
            // puts("\tmovq %rbp, %rsp");
            
            puts("\tret");
            break;
        case IF_STATEMENT :
            //puts("/* if section commented out because it doesn't work");
            ; 
            curr_lab = label_c;
            label_c++;

            printf("\t# beginning rhs of %c relation\n", *(char*)curr->children[0]->data);
            translate(curr->children[0]->children[1], func);
            puts("\t# end rhs");
            // free rax by pushing on the stack
            puts("\tpushq %rax");
            // translate the second expression
            printf("\t#beginning of lhs of %c expresion\n", *(char*)curr->children[0]->data);
            translate(curr->children[0]->children[0], func);
            printf("\t# end of lhs\n");
            // pop the first result into r10
            puts("\tpopq %r10");
            puts("cmpq %r10, %rax");
            switch (*(char*)curr->children[0]->data) {
                case '<' :
                    printf("\tjge .L%d\n", curr_lab);
                    break;
                case '>' :
                    printf("\tjle .L%d\n", curr_lab);
                    break;
                case '=' :
                    printf("\tjne .L%d\n", curr_lab);
                    break;
                default :
                    break;
            }
            translate(curr->children[1], func);
            printf("\tjmp .E%d\n", curr_lab);
            printf(".L%d:\n", curr_lab);
            if(curr->n_children == 3) {
               translate(curr->children[2], func); 
            }
            printf(".E%d:\n", curr_lab);
            //puts("*/");
            break;
        case WHILE_STATEMENT :
            curr_lab = label_c;

            label_c++;
            printf("B%d:", curr_lab);

            printf("\t# beginning rhs of %c relation\n", *(char*)curr->children[0]->data);
            translate(curr->children[0]->children[1], func);
            puts("\t# end rhs");
            // free rax by pushing on the stack
            puts("\tpushq %rax");
            // translate the second expression
            printf("\t#beginning of lhs of %c expresion\n", *(char*)curr->children[0]->data);
            translate(curr->children[0]->children[0], func);
            printf("\t# end of lhs\n");
            // pop the first result into r10
            puts("\tpopq %r10");
            puts("cmpq %r10, %rax");
            switch (*(char*)curr->children[0]->data) {
                case '<' :
                    printf("\tjge .E%d\n", curr_lab);
                    break;
                case '>' :
                    printf("\tjle .E%d\n", curr_lab);
                    break;
                case '=' :
                    printf("\tjne .E%d\n", curr_lab);
                    break;
                default :
                    break;
            }
            translate(curr->children[1], func);
            printf("\tjmp B%d\n", curr_lab);

            printf(".E%d:\n", curr_lab);

            break;



        default:
            break;
    }

}

static void
traverse_function(symbol_t* func_symbol){
    // Allocate stack for local variables
    size_t localsize = tlhash_size(func_symbol->locals);
    puts("\tpushq %rbp");
    puts("\tmovq %rsp, %rbp");
    for( int i = 0; i< MIN(6, func_symbol->nparms); i++){
        printf("\tpushq %s\n", record[i]);
    }
    printf("\tsubq $%zu, %%rsp\n", 8*localsize);
    if((localsize + func_symbol->nparms) % 2 != 0)  puts("\tsubq $8, %rsp");

    translate(func_symbol->node, func_symbol);
}


static void
generate_functions( void )
{
    size_t n_globals = tlhash_size ( global_names );
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    for(int i = 0; i< n_globals; i++){
        symbol_t *glob = global_list[i];
        if(glob->type == SYM_FUNCTION){
            printf("_%s:\n", glob->name);

            // Actual function code
            traverse_function(glob);
            // might be unneccessary, each functin has a return statement anyways
            //puts("\tmovq %rbp, %rsp");
            //puts("\tret");
        }
    }
}


static void
generate_main ( symbol_t *first )
{
    puts ( ".globl main" );
    puts ( ".text" );
    puts ( "main:" );
    puts ( "\tpushq %rbp" );
    puts ( "\tmovq %rsp, %rbp" );

    puts ( "\tsubq $1, %rdi" );
    printf ( "\tcmpq\t$%zu,%%rdi\n", first->nparms );
    puts ( "\tjne ABORT" );
    puts ( "\tcmpq $0, %rdi" );
    puts ( "\tjz SKIP_ARGS" );

    puts ( "\tmovq %rdi, %rcx" );
    printf ( "\taddq $%zu, %%rsi\n", 8*first->nparms );
    puts ( "PARSE_ARGV:" );
    puts ( "\tpushq %rcx" );
    puts ( "\tpushq %rsi" );

    puts ( "\tmovq (%rsi), %rdi" );
    puts ( "\tmovq $0, %rsi" );
    puts ( "\tmovq $10, %rdx" );
    puts ( "\tcall strtol" );

    /*  Now a new argument is an integer in rax */
    puts ( "\tpopq %rsi" );
    puts ( "\tpopq %rcx" );
    puts ( "\tpushq %rax" );
    puts ( "\tsubq $8, %rsi" );
    puts ( "\tloop PARSE_ARGV" );

    /* Now the arguments are in order on stack */
    for ( int arg=0; arg<MIN(6,first->nparms); arg++ )
        printf ( "\tpopq\t%s\n", record[arg] );

    puts ( "SKIP_ARGS:" );
    printf ( "\tcall\t_%s\n", first->name );
    puts ( "\tjmp END" );
    puts ( "ABORT:" );
    puts ( "\tleaq errout(%rip), %rdi" );
    puts ( "\tcall puts" );

    puts ( "END:" );
    puts ( "\tmovq %rax, %rdi" );
    puts ( "\tcall exit" );
}


void
generate_program ( void )
{
    generate_stringtable();
    generate_globalvars();

    generate_main(first);
    generate_functions();

    /* Put some dummy stuff to keep the skeleton from crashing */
    /*
    puts ( ".globl main" );
    puts ( ".text" );
    puts ( "main:" );
    puts ( "\tmovq $0, %rax" );
    puts ( "\tcall exit" );
    */
}
