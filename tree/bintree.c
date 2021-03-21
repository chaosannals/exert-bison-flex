#include "bintree.h"

bintree_t *new_node() {
    return (bintree_node_t*)malloc(sizeof(bintree_node_t));
}