#include <vslc.h>

// Externally visible, for the generator
extern tlhash_t *global_names;
extern char **string_list;
extern size_t n_string_list,stringc;

int seq_counter = 0;

// Struct for the linked hash table list

typedef struct t {
    tlhash_t* hash;
    struct t* next;
} hash_list;


/* External interface */

void create_symbol_table(void);
void print_symbol_table(void);
void print_symbols(void);
void print_bindings(node_t *root);
void destroy_symbol_table(void);
void find_globals(void);
void bind_names(symbol_t *function, node_t *root);
void destroy_symtab(void);


void process_rec(node_t* current, int scope, hash_list* hash_scope, tlhash_t* locals, int counter);

void insert_entries(hash_list* nhl, tlhash_t* locals, int counter);
void add_hashscope(node_t* decl_node, hash_list* hash_scope);
int lookup(node_t* id_node, hash_list* hash_scope);
void add_string(char* str);




void
create_symbol_table ( void )
{
  find_globals();
  size_t n_globals = tlhash_size ( global_names );
  symbol_t *global_list[n_globals];
  tlhash_values ( global_names, (void **)&global_list );
  
  for ( size_t i=0; i<n_globals; i++ )
      if ( global_list[i]->type == SYM_FUNCTION ) {
          seq_counter = 0;
          bind_names ( global_list[i], global_list[i]->node);
      }
}


void
print_symbol_table ( void )
{
	print_symbols();
	print_bindings(root);
}

void
print_symbols ( void )
{
    printf ( "String table:\n" );
    for ( size_t s=0; s<stringc; s++ )
        printf  ( "%zu: %s\n", s, string_list[s] );
    printf ( "-- \n" );

    printf ( "Globals:\n" );
    size_t n_globals = tlhash_size(global_names);
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
    for ( size_t g=0; g<n_globals; g++ )
    {
        switch ( global_list[g]->type )
        {
            case SYM_FUNCTION:
                printf (
                    "%s: function %zu:\n",
                    global_list[g]->name, global_list[g]->seq
                );
                if ( global_list[g]->locals != NULL )
                {
                    size_t localsize = tlhash_size( global_list[g]->locals );
                    printf (
                        "\t%zu local variables, %zu are parameters:\n",
                        localsize, global_list[g]->nparms
                    );
                    symbol_t *locals[localsize];
                    tlhash_values(global_list[g]->locals, (void **)locals );
                    for ( size_t i=0; i<localsize; i++ )
                    {
                        printf ( "\t%s: ", locals[i]->name );
                        switch ( locals[i]->type )
                        {
                            case SYM_PARAMETER:
                                printf ( "parameter %zu\n", locals[i]->seq );
                                break;
                            case SYM_LOCAL_VAR:
                                printf ( "local var %zu\n", locals[i]->seq );
                                break;
                        }
                    }
                }
                break;
            case SYM_GLOBAL_VAR:
                printf ( "%s: global variable\n", global_list[g]->name );
                break;
        }
    }
    printf ( "-- \n" );
}


void
print_bindings ( node_t *root )
{
    if ( root == NULL )
        return;
    else if ( root->entry != NULL )
    {
        switch ( root->entry->type )
        {
            case SYM_GLOBAL_VAR: 
                printf ( "Linked global var '%s'\n", root->entry->name );
                break;
            case SYM_FUNCTION:
                printf ( "Linked function %zu ('%s')\n",
                    root->entry->seq, root->entry->name
                );
                break; 
            case SYM_PARAMETER:
                printf ( "Linked parameter %zu ('%s')\n",
                    root->entry->seq, root->entry->name
                );
                break;
            case SYM_LOCAL_VAR:
                printf ( "Linked local var %zu ('%s')\n",
                    root->entry->seq, root->entry->name
                );
                break;
        }
    } else if ( root->type == STRING_DATA ) {
        size_t string_index = *((size_t *)root->data);
        if ( string_index < stringc )
            printf ( "Linked string %zu\n", *((size_t *)root->data) );
        else
            printf ( "(Not an indexed string)\n" );
    }
    for ( size_t c=0; c<root->n_children; c++ )
        print_bindings ( root->children[c] );
}


void
destroy_symbol_table ( void )
{
      destroy_symtab();
}







static void add_global ( symbol_t *symbol ) {
    tlhash_insert ( global_names, symbol->name, strlen(symbol->name), symbol );
}

void
find_globals ( void )
{
    // MLC01
    global_names = malloc( sizeof(tlhash_t) );
    tlhash_init( global_names, 32 );
    // MLC02
    string_list = malloc( n_string_list * sizeof(char * ) );
    int n_functions = 0;
    node_t* gl_node = root->children[0];
    // we are only interested in global variables and functions, so we will only look
    // at the children of the global list (which is the first and only child of the root 
    // node).
    for (int i = 0; i < gl_node->n_children; i++) {
        node_t* current_node = gl_node->children[i];
        switch (current_node->type) {
            case FUNCTION: ;
                // If the type is function, create a symbol_t that already includes a local hash table
                // of all the parameters of the function so they can be used inside.
                // MLC03
                symbol_t* symbol = malloc(sizeof(symbol_t));
                symbol->name = current_node->children[0]->data;
                symbol->type = SYM_FUNCTION;
                symbol->node = current_node;
                // MLC04
                symbol->locals = malloc(sizeof(tlhash_t));
                //also add the entry to the node
                current_node->entry = symbol;

                // INI01
                tlhash_init(symbol->locals, 32);
                if (current_node->children[1] != NULL) {
                    symbol->nparms = current_node->children[1]->n_children;
                    // ADD PARAMS TO LOCAL HASH TABLE                    
                    for (int j = 0; j < current_node->children[1]->n_children; j++) {
                        // MLC05
                        symbol_t* sym_param = malloc(sizeof(symbol_t));
                        sym_param->seq = j;
                        sym_param->name = current_node->children[1]->children[j]->data;
                        sym_param->type = SYM_PARAMETER;
                        // i think this is right
                        sym_param->node = current_node->children[1]->children[j];
                        sym_param->locals = NULL;
                        // also add the entry to the node
                        current_node->children[1]->children[j]->entry = sym_param;
                        tlhash_insert ( symbol->locals, sym_param->name, strlen(sym_param->name), sym_param );
                    }
                } else {
                    symbol->nparms = 0;                
                }
                symbol->seq = n_functions;
                add_global(symbol);
                n_functions++;
                break;
            case DECLARATION: ;
            	// For global variable declarations simply add the variable
                for (int j = 0; j < current_node->children[0]->n_children; j++) {
                    node_t* c_node = current_node->children[0]->children[j];
                    // MLC06
                    symbol_t* symbol = malloc(sizeof(symbol_t));
                    symbol->name = c_node->data;
                    symbol->type = SYM_GLOBAL_VAR;
                    symbol->node = c_node;
                    symbol->nparms = 0;
                    symbol->locals = NULL;
                    // also add the entry to the node;
                    c_node = symbol;
                    add_global(symbol);
                }
                //printf("\n");
                break;   
        }
    }
}

void
bind_names ( symbol_t *function, node_t *root )
{
    int scope = 0; // How deeply nested inside scopes
    int counter = 0; // Block counter in order to create unique hash keys in the functions table, even with variables of the same name in nested blocks
    int seq_counter = 0; // Counter for the sequence numbers of the local variables
    // Initialize list/stack of block-specific lookup tables
    // MLC07
    hash_list* nhl = malloc(sizeof(hash_list));
    nhl->hash = function->locals;
    nhl->next = NULL;
    for (int i = 0; i < root->children[2]->n_children; i++) {
        process_rec(root->children[2]->children[i], scope, nhl, function->locals, counter);
    }
    // FRR07
    free(nhl);
}

void process_rec(node_t* current, int scope, hash_list* hash_scope, tlhash_t* locals, int counter) {
    if(current == NULL){
        return;
    }
    switch(current->type) {
        case BLOCK:
        	// Increase the block counter as well as the scope depth counter since we have gone one level deeper
            counter++;
            scope++;
            // new hash table
            // MLC08
            tlhash_t* nht = malloc(sizeof(tlhash_t));
            tlhash_init(nht, 32);
            // Add the new hash table to the top of the stack
            // MLC09
            hash_list* nhl = malloc(sizeof(hash_list));
            nhl->hash = nht;
            nhl->next = hash_scope;
            // recursively process all children
            for (int i = 0; i < current->n_children; i++) {
                process_rec(current->children[i], scope, nhl, locals, counter);
            }
            // add the entries of the local lookup table to the functions table
            insert_entries(nhl, locals, counter);
            tlhash_finalize(nhl->hash);
            // FRR08
            free(nht);
            // FRR09
            free(nhl);
            // reduce the nesting counter again
            scope--;
            break;
        case DECLARATION:
            //node_print(current, 1);
            // add the declared variables to the lookup table
            add_hashscope(current, hash_scope);
            break;
        case IDENTIFIER_DATA: ;
            int result = lookup(current, hash_scope);
            if (result == 0) {
                printf("\n\nFUCKUP !!!!!!!!!!!!!!\n\n\n");
            }
            break;
        case STRING_DATA:
        	// add the string to our global string list
            //printf("%s\n", current->data);
            add_string(current->data);
            // MLC10
            current->data = malloc(sizeof(size_t)); 
            *(size_t*) current->data = stringc-1;
            break;
        default:
        	// for all other nodes do nothing, just recurse
            for (int i = 0; i < current->n_children; i++) {
                process_rec(current->children[i], scope, hash_scope, locals, counter);
            }
            break;
            
    }
}

void add_string(char* str) {
	// On discovery of the first string, allocate space for 4 strings in advance
    if(n_string_list == 0){
        n_string_list = 4;
        // MLC11
        string_list = malloc(n_string_list*sizeof(char*));
    }
    // In case the string list is too short, double the length and reallocate it
    if(stringc > n_string_list){
        n_string_list = 2*n_string_list;
        string_list = realloc(string_list, n_string_list*sizeof(char*));
    }
    string_list[stringc] = str;
    stringc++;
}


void insert_entries(hash_list* nhl, tlhash_t* locals, int counter) {
    int size = tlhash_size(nhl->hash);
    symbol_t* valuelist[size];
    // Get all the names that need to be inserted
    tlhash_values(nhl->hash, valuelist);
    for (int i = 0; i < size; i++) {
        char keyname[100];
        // Create the name from the counter and the name (f.ex. "12x")
        //snprintf(keyname, 100, "%d%s", counter, valuelist[i]->name);
        snprintf(keyname, 100, "local_%d",  valuelist[i]->seq);
        printf(keyname);
        int r = tlhash_insert(locals, keyname, strlen(keyname), valuelist[i]);
        //printf("%d\n", r);
    }
}

void add_hashscope(node_t* decl_node, hash_list* hash_scope) {
    for (int i = 0; i < decl_node->children[0]->n_children; i++) {
        node_t* c_node = decl_node->children[0]->children[i];
        // MLC12
        symbol_t* sym = malloc(sizeof(symbol_t));
        sym->name = c_node->data;
        sym->type = SYM_LOCAL_VAR;
        sym->node = decl_node->children[0]->children[i];
        sym->nparms = 0;
        sym->locals = NULL;
        sym->seq = seq_counter;
        // also add the entry to the node
        decl_node->children[0]->children[i]->entry = sym;
        int r = tlhash_insert(hash_scope->hash, c_node->data, strlen(c_node->data), sym);
        //printf("%d\n", r);
        seq_counter++;
    }
}

int lookup(node_t* id_node, hash_list* hash_scope) {
    // Loop through all the lookup tables in the stack from top to bottom to find the
    // relevant binding
    symbol_t* sym = NULL;
    do {
        int r = tlhash_lookup(hash_scope->hash, id_node->data, strlen(id_node->data), (void**)&sym);
        if (r == TLHASH_SUCCESS) return 1;
        hash_scope = hash_scope->next;
    } while (hash_scope != NULL);
    // if no symbol is found in the local table, check the global table
    int r = tlhash_lookup(global_names, id_node->data, strlen(id_node->data), (void**)&sym);
    if (r == TLHASH_SUCCESS) {
        return 1;
    } else {
        return 0;
    }
}

void
destroy_symtab ( void )
{
    size_t n_globals = tlhash_size ( global_names );
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );
  
    for ( size_t i=0; i<n_globals; i++ )
        if ( global_list[i]->type == SYM_FUNCTION ) {
            free_func ( global_list[i]);
        } else {
            // FRR06
            free(global_list[i]);
        }

    // FRR01
    tlhash_finalize(global_names);
    free(global_names);

    //
    for(int i = 0; i<stringc; i++){
        free(string_list[i]);
    }
    // FRR02
    free(string_list);
    
}

void
free_func(symbol_t* func){
    size_t n_locals = tlhash_size ( func->locals );
    symbol_t *local_list[n_locals];
    tlhash_values( func->locals, (void**)&local_list);

    for( size_t i=0; i<n_locals; i++) 
        // FRR05
        free(local_list[i]);
    
    tlhash_finalize(func->locals);
    // FRR04
    free(func->locals);
    // FRR03
    free(func);
}
    
