#ifndef IR_H
#define IR_H

typedef struct n {
    node_index_t type;
    void *data;
    void *entry;
    uint64_t n_children;
    struct n **children;
} node_t;

void node_init (
    node_t *n, node_index_t type, void *data, uint64_t n_children, ...
);
void node_print ( node_t *root, int nesting );
void node_finalize ( node_t *discard );
void destroy_subtree ( node_t *discard );

void flatten(node_t **childlist, node_t *current, int curritem);
int itemcount(node_t *root);
bool check_doable(node_t* root);
int do_it(node_t* root);
void simplify_tree ( node_t **simplified, node_t *root );

#endif
