#ifndef BFC_BINTREE_H
#define BFC_BINTREE_H
typedef struct bintree_node {
    struct bintree_node *left;
    struct bintree_node *right;
} bintree_node_t;

typedef struct bintree {
    struct bintree_node *root;
} bintree_t;
#endif
