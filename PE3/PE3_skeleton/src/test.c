#include <stdio.h>
#include <stdlib.h>
#include "../include/vslc.h"

node_t *root;

int
main ( int argc, char **argv )
{
	node_t *n = NULL;
	n = malloc(sizeof(node_t));	
	
	node_t *one = NULL;
	one = malloc(sizeof(node_t));	
	one->n_children = 0;
	one->type = STRING_DATA;
	one->data = "one";
	
	node_t *two = NULL;
	two = malloc(sizeof(node_t));	

	node_t *three = NULL;
	three = malloc(sizeof(node_t));	
	three->n_children = 0;
	three->type = STRING_DATA;
	three->data = "three";
	
	node_t *four = NULL;
	four = malloc(sizeof(node_t));	
	four->n_children = 0;
	four->type = STRING_DATA;
	four->data = "four";
	
	node_t *five = NULL;
	five = malloc(sizeof(node_t));	
	five->n_children = 0;
	five->type = STRING_DATA;
	five->data = "five";
	
	node_init(two, STRING_DATA,"two", 2, four, five);
	node_init(n, STRING_DATA,"root", 3, one, two, three);
	
	root = n;
    node_print ( root, 1 );
    destroy_subtree ( root->children[1] );
    //node_finalize( root->children[2] );
    
    node_print( root, 1 );
    
    destroy_subtree ( root );
	
	printf("\n");
    node_print ( root, 1 );
    
    node_finalize(root);
}
