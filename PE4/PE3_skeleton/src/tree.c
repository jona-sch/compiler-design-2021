#include "../include/vslc.h"

void
node_print ( node_t *root, int nesting )
{
    if ( root != NULL )
    {
        /* Print the type of node indented by the nesting level */
        printf ( "%*c%s", nesting, ' ', node_string[root->type] );

        /* For identifiers, strings, expressions and numbers,
         * print the data element also
         */
        if ( root->type == IDENTIFIER_DATA ||
             root->type == STRING_DATA ||
             root->type == EXPRESSION ) 
            printf ( "(%s)", (char *) root->data );
        else if ( root->type == NUMBER_DATA )
            printf ( "(%lld)", *((int64_t *)root->data) );

        /* Make a new line, and traverse the node's children in the same manner */
        putchar ( '\n' );
        for ( int64_t i=0; i<root->n_children; i++ )
            node_print ( root->children[i], nesting+1 );
    }
    else
        printf ( "%*c%p\n", nesting, ' ', root );
}


/* Take the memory allocated to a node and fill it in with the given elements */
void node_init (node_t *nd, node_index_t type, void *data, uint64_t n_children, ...)
{
	va_list ap;
	
    nd->type = type;
    nd->data = data;
    nd->n_children = n_children;
    
    va_start(ap, n_children);
    node_t** tmp = malloc(sizeof(node_t*) * n_children);
    for (int i = 0; i < n_children; i++) {
    	tmp[i] = va_arg(ap, node_t*);
    }
    va_end(ap);
    
    nd->children = tmp;
}


/* Remove a node and its contents */
void
node_finalize ( node_t *discard )
{
		//free(discard->data);
		if ( discard != NULL ) {
				if(discard->type == STRING || discard->type == NUMBER || discard->type == IDENTIFIER) free(discard->data);
				free(discard->children);
				free(discard);
		}
}


/* Recursively remove the entire tree rooted at a node */
void
destroy_subtree ( node_t *discard )
{
		if ( discard != NULL ) {
				for (int i = discard->n_children - 1; i >= 0; i--) {
					destroy_subtree((discard->children)[i]);
					node_finalize((discard->children)[i]); 
				}   
				discard->n_children = 0;
		}
}


// Puts all the items in a LIST node into childlist
void flatten(node_t **childlist, node_t *current, int curritem){
	if (current->n_children == 0) {
		return;
	}
	if (current->n_children == 1) {
		childlist[curritem] = current->children[0];
	}
	else {
		childlist[curritem] = current->children[1];
		flatten(childlist, current->children[0], curritem-1);
		if (curritem != 0){
			node_finalize(current->children[0]);
		}
	}
}


// Counts the number of items in a LIST node
int itemcount(node_t *root){
	if (root->n_children == 0){
		return 0;
		}
	if (root->n_children == 1){
		return 1;
		}
	return itemcount(root->children[0]) + 1;
}


// Recursively checks if an EXPRESSION node can be entirely simplified to a NUMBER_DATA node
bool check_doable(node_t* root) {
	if (root->n_children == 0) {
		if (root->type == NUMBER_DATA) {
			return true;
		} else {
			return false;
		}
	} else if (root->n_children == 1) {
		return check_doable(root->children[0]);
	} else if (root->n_children == 2) {
		return check_doable(root->children[0]) && check_doable(root->children[1]);
	}
}


// Recursively computes an expression with only NUMBER_DATA in it
int do_it(node_t* root) {
	if (root->n_children == 0) {
		return *((int64_t *)root->data);
	}
	else if (root->n_children == 1) {
		if (!strcmp(root->data,"~")) {
			// i dont know what thats supposed to be, we just return without modification
			return ~do_it(root->children[0]);
		} else if (!strcmp(root->data,"-")) {
			return -1*do_it(root->children[0]);
		}
	}
	else if (root->n_children == 2) {
		if (!strcmp(root->data,"/")) {
			return do_it(root->children[0])/do_it(root->children[1]);
		} else if (!strcmp(root->data,"+")) {
			return do_it(root->children[0])+do_it(root->children[1]);
		} else if (!strcmp(root->data,"-")) {
			return do_it(root->children[0])-do_it(root->children[1]);
		} else if (!strcmp(root->data,"*")) {
			return do_it(root->children[0])*do_it(root->children[1]);
		} else if (!strcmp(root->data,"|")) {
			return do_it(root->children[0]) | do_it(root->children[1]);
		} else if (!strcmp(root->data, "^")) {
			return do_it(root->children[0]) ^ do_it(root->children[1]);
		} else if (!strcmp(root->data,"&")) {
			return do_it(root->children[0]) & do_it(root->children[1]);
	        } else if (!strcmp(root->data,">>")) {
			return do_it(root->children[0]) >> do_it(root->children[1]);
		}else if (!strcmp(root->data,"<<")) {
			return do_it(root->children[0]) << do_it(root->children[1]);
		} else {
			return do_it(root->children[0]);
		}
	}
}


// Recursively simplifies a tree computed by yyparse
void
simplify_tree ( node_t **simplified, node_t *root )
{
    *simplified = root;
    for (int i = 0; i < root->n_children; i++){
    // we iterate over all the childs of the node
    
    	if (root->children[i] == NULL) { 
    		// if a node is NULL, we have nothing to do, simply go to next node
    	} else { 
    		// the node is not NULL
      	
		  	if (root->children[i]->type == GLOBAL || root->children[i]->type == STATEMENT || root->children[i]->type == PRINT_ITEM || (root->children[i]->type == EXPRESSION && !strcmp(root->children[i]->data, ""))) { 
		  		// case 1: useless node, we simplify by replacing it by its child
		  		node_t *tmp = root->children[i];
		  		root->children[i] = root->children[i]->children[0];
		  		simplify_tree(&root->children[i], root->children[i]);
		  		node_finalize(tmp);
		  	} 
		  	
		  	else {
		  	
		  		if (root->children[i]->type == EXPRESSION) {
		  			// case 2: expression node (wih at least one child, else see case 1)
		  			// We check if a simplification of the expression is possible. A simplification is possible only if
		  			// it reduces the whole EXPRESSION subtree to a NUMBER_DATA node. Not the most efficient, we browse
		  			// some subtrees multiple times.
		  			
		  			if (check_doable(root->children[i])) {
		  				// If a whole reduction is possible, we compute the resulting value and refactor the EXPRESSION node
		  				// to become a NUMBER_DATA node with the right value. We also free the useless nodes.
		  				int value = do_it(root->children[i]);
		  				//printf("\n\n%lld\n\n",value);
		  				root->children[i]->type = NUMBER_DATA;
		  				root->children[i]->data = (int64_t*)malloc(sizeof(int64_t));
		  				*((int64_t*)(root->children[i]->data)) = value;
		  				destroy_subtree(root->children[i]);
		  			} else {
		  				// If a whole reduction is not possible, we continue our simplification on the childs.
		  				simplify_tree(&root->children[i], root->children[i]);
		  			}
		  		} 
		  		
		  		else {
		  			// case 3: lists.
		  			// Separated in two:
						if (root->children[i]->type == PARAMETER_LIST || root->children[i]->type == ARGUMENT_LIST || root->children[i]->type == PRINT_STATEMENT) {
							// case 3a: list nodes that are not "true" list nodes. PARAMETER_LIST and ARGUMENT_LIST nodes only have one child which is a "true" list.
							// The idea is to remove the intermediate list node, making those list nodes "true" list nodes that we can flatten (in case 3b).
							// Example:
							//
							//       PL                           PL
							//       |                        |         |
							//       |                        LI        VL
							//       VL                              |      |
							//		|      |	          =>             LI     VL
							//    LI     VL                                 |
							//         |     |                              LI
							//         LI    VL
							//               |
							//               LI
							//
							// (PL: PARAMETER_LIST, VL: VARIABLE_LIST, LI: LIST_ITEM)
							//
							// It doesn't matter that the list nodes are not consistent, the flattening in case 3b doesn't care.
							node_t *tmp = root->children[i];
							root->children[i] = root->children[i]->children[0];
							root->children[i]->type = tmp->type;
							node_finalize(tmp);
						}
						
						if (root->children[i]->type == GLOBAL_LIST || root->children[i]->type == STATEMENT_LIST || root->children[i]->type == PRINT_LIST || root->children[i]->type == EXPRESSION_LIST || root->children[i]->type == VARIABLE_LIST || root->children[i]->type == DECLARATION_LIST || root->children[i]->type == PARAMETER_LIST || root->children[i]->type == ARGUMENT_LIST || root->children[i]->type == PRINT_STATEMENT){
							// case 3b: list nodes that we can flatten.
							// Steps: 1) compute size of the list (=number of items)
							//        2) allocate memory for the list of the items
							//        3) flatten the list recursively, storing the items in the previoulsy allocated list
							//        4) set the newly created list as the children of the current node, set the current value for number of childrens
							//        5) simplify childs
							int items = itemcount(root->children[i]);
							if (items > 0) {
								node_t **childlist = malloc(sizeof(node_t*) * items);
								flatten(childlist, root->children[i], items-1);
								root->children[i]->children = childlist;
								root->children[i]->n_children = items;
								simplify_tree(&root->children[i], root->children[i]);
							}
										
						} 
						// case 4: none of the above, nothing to simplify here, continue simplification on childs.
						else {
							 	simplify_tree(&root->children[i], root->children[i]);
						}
					}
				}
		  }
    }
    	
    
}
