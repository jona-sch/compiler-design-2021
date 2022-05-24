#include <stdio.h>
#include <stdlib.h>
#include "../include/vslc.h"

node_t *root;
extern YYSTYPE yylval;

int
main ( int argc, char **argv )
{
    yylval = malloc(sizeof(node_t));
    
    yyparse();
    simplify_tree(&root, root);


 	 	//while (1) {
  	//	  token = yyparse();
    //		printf("%d\n",token);
   	//		if (token == 0) { //end of file
    //				break;
    ////		}
  	//} 
  
    node_print ( root, 0 );
    destroy_subtree ( root );
    free(yylval);
}
