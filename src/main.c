
#include <stdio.h> 
#include "node.c"


int main(int argc, char *argv[])
{
	/*
	 * 					n
	 * 				t		a
	 * 			b
	 * */
	
	Node** children;
	
	Node* b = create_leaf(4,305, "lexeme ( b ) \n", NULL);
	pack_nodes(&children, 0, b);
	
	Node* t = create_node(23, 305, "lexeme ( t ) \n", NULL, 1, children);

	free(children);
	
	Node* a = create_leaf(5, 302, "lexeme ( a ) \n", NULL);
	pack_nodes(&children, 0, t);
	pack_nodes(&children, 1, a);

	Node* n = create_node(5, 302, "lexeme ( n ) : root  \n", NULL, 2, children);
	
	free(children);
	
	/* imprime a altura da arvore */
	printf ( "height: %d \n", height(a));
	printf ( "%s" , n->lexeme);
	printf ( "%s" , child(n,1)->lexeme);
	printf ( "%s" , child(n,2)->lexeme);
	printf ( "%s", child(child(n,1),1)->lexeme);

		
	deep_free_node(n);

	return 0;
	
}
