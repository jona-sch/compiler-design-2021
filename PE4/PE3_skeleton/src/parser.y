%{
#include <vslc.h>
%}
%left '|'
%left '^'
%left '&'
%left LSHIFT RSHIFT
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%right '~'
%expect 1

%token FUNC PRINT RETURN CONTINUE IF THEN ELSE WHILE DO OPENBLOCK CLOSEBLOCK
%token VAR NUMBER IDENTIFIER STRING LSHIFT RSHIFT

%%
program : global_list {
																				//node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				root = malloc(sizeof(node_t));
																				node_init ( root, PROGRAM, "", 1, $1 );
																				
																			};
global_list : global {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, GLOBAL_LIST, "", 1, $1 );
																				$$ = node;
																			}
					| global_list global {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, GLOBAL_LIST, "", 2, $1, $2 );
																				$$ = node;
																			};
global : function {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, GLOBAL, "", 1, $1 );
																				$$ = node;
																			}
					| declaration {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, GLOBAL, "", 1, $1 );
																				$$ = node;
																			};
statement_list : statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, STATEMENT_LIST, "", 1, $1 );
																				$$ = node;
																			}
					| statement_list statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, STATEMENT_LIST, "", 2, $1, $2 );
																				$$ = node;
																			};
print_list : print_item {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, PRINT_LIST, "", 1, $1 );
																				$$ = node;
																			}
					| print_list ',' print_item {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, PRINT_LIST, "", 2, $1, $3 );
																				$$ = node;
																			};
expression_list : expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION_LIST, "", 1, $1 );
																				$$ = node;
																			}
					| expression_list ',' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION_LIST, "", 2, $1, $3 );
																				$$ = node;
																			};
variable_list : identifier {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, VARIABLE_LIST, "", 1, $1 );
																				$$ = node;
																			}
					| variable_list ',' identifier {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, VARIABLE_LIST, "", 2, $1, $3 );
																				$$ = node;
																			};
argument_list : expression_list {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, ARGUMENT_LIST, "", 1, $1 );
																				$$ = node;
																			}
					| { $$ = NULL; };
parameter_list : variable_list {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, PARAMETER_LIST, "", 1, $1 );
																				$$ = node;
																			}
					| { $$ = NULL; };
declaration_list : declaration {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, DECLARATION_LIST, "", 1, $1 );
																				$$ = node;
																			}
					| declaration_list declaration {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, DECLARATION_LIST, "", 2, $1, $2 );
																				$$ = node;
																			};
function : FUNC identifier '(' parameter_list ')' statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, FUNCTION, "", 3, $2, $4, $6 );
																				$$ = node;
																			};
statement : assign_statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, STATEMENT, "", 1, $1 );
																				$$ = node;
																			}
					| return_statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, STATEMENT, "", 1, $1 );
																				$$ = node;
																			}
					| print_statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, STATEMENT, "", 1, $1 );
																				$$ = node;
																			}
					| if_statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, STATEMENT, "", 1, $1 );
																				$$ = node;
																			}
					| while_statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, STATEMENT, "", 1, $1 );
																				$$ = node;
																			}
					| null_statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, STATEMENT, "", 1, $1 );
																				$$ = node;
																			}
					| block {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, STATEMENT, "", 1, $1 );
																				$$ = node;
																			};
block : OPENBLOCK declaration_list statement_list CLOSEBLOCK {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, BLOCK, "", 2, $2, $3 );
																				$$ = node;
																			}
					| OPENBLOCK statement_list CLOSEBLOCK {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, BLOCK, "", 1, $2 );
																				$$ = node;
																			};
assign_statement : identifier ':' '=' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, ASSIGNMENT_STATEMENT, "", 2, $1, $4 );
																				$$ = node;
																			};
return_statement : RETURN expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, RETURN_STATEMENT, "", 1, $2 );
																				$$ = node;
																			};
print_statement : PRINT print_list {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, PRINT_STATEMENT, "", 1, $2 );
																				$$ = node;
																			}; 
null_statement : CONTINUE  {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, NULL_STATEMENT, "", 0);
																				$$ = node;
																			}; 
if_statement : IF relation THEN statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, IF_STATEMENT, "", 2, $2, $4 );
																				$$ = node;
																			}; 
if_statement : IF relation THEN statement ELSE statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, IF_STATEMENT, "", 3, $2, $4, $6 );
																				$$ = node;
																			};
while_statement : WHILE relation DO statement {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, WHILE_STATEMENT, "", 2, $2, $4 );
																				$$ = node;
																			};
relation : expression '=' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, RELATION, "=", 2, $1, $3 );
																				$$ = node;
																			}
						| expression '<' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, RELATION, "<", 2, $1, $3 );
																				$$ = node;
																			}
						| expression '>' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, RELATION, ">", 2, $1, $3 );
																				$$ = node;
																			};
expression : expression '|' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "|", 2, $1, $3 );
																				$$ = node;
																			}
						| expression '^' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "^", 2, $1, $3 );
																				$$ = node;
																			}
						| expression '&' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "&", 2, $1, $3 );
																				$$ = node;
																			}
						| expression LSHIFT expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "<<", 2, $1, $3 );
																				$$ = node;
																			}
						| expression RSHIFT expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, ">>", 2, $1, $3 );
																				$$ = node;
																			}
						| expression '+' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "+", 2, $1, $3 );
																				$$ = node;
																			}
						| expression '-' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "-", 2, $1, $3 );
																				$$ = node;
																			}
						| expression '*' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "*", 2, $1, $3 );
																				$$ = node;
																			}
						| expression '/' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "/", 2, $1, $3 );
																				$$ = node;
																			}
						| '-' expression %prec UMINUS {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "-", 1, $2 );
																				$$ = node;
																			}
						| '~' expression {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "~", 1, $2 );
																				$$ = node;
																			}
						| '(' expression ')' {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "", 1, $2 );
																				$$ = node;
																			}
						| number 
						| identifier 
						| identifier '(' argument_list ')' {
																				node_t* node = (node_t *) malloc ( sizeof(node_t) );
																				node_init ( node, EXPRESSION, "call", 2, $1, $3 );
																				$$ = node;
																			};
declaration : VAR variable_list {
        node_t* var_node = (node_t *) malloc ( sizeof(node_t) );
        node_init ( var_node, DECLARATION, "", 1, $2 );
        $$ = var_node;
      };
print_item : expression {
        node_t* var_node = (node_t *) malloc ( sizeof(node_t) );
        node_init ( var_node, PRINT_ITEM, "", 1, $1 );
        $$ = var_node;
      }
						| string {
        node_t* var_node = (node_t *) malloc ( sizeof(node_t) );
        node_init ( var_node, PRINT_ITEM, "", 1, $1 );
        $$ = var_node;
				};
identifier : IDENTIFIER {
        $$ = (node_t *) malloc ( sizeof(node_t) );
        node_init ( $$, IDENTIFIER_DATA, $1->data, 0 );  // put name of identifier in
      };
number :  NUMBER {
        node_t* nb_node = (node_t *) malloc ( sizeof(node_t) );
        node_init ( nb_node, NUMBER_DATA, $1->data, 0 ); // put correct number in
        $$ = nb_node;
      };
string : STRING {
        node_t* str_node = (node_t *) malloc ( sizeof(node_t) );
        node_init ( str_node, STRING_DATA, $1->data, 0 );  // put correct string in
        $$ = str_node;
      };
%%

int
yyerror ( const char *error )
{
    fprintf ( stderr, "%s on line %d\n", error, yylineno );
    exit ( EXIT_FAILURE );
}
