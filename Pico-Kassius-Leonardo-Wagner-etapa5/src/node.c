#include "node.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Pode ser util...*/
static int __nodes_ids__ = 0;

Node* create_node(int nl, Node_type t, char* lex, 
                  void* att, int nbc, Node** children) {
	
	/* aloca memoria para um nodo novo */
	Node* node = calloc(1,sizeof(Node));
	
	/* verifica se a quantidade de filhos eh valida */		
	if (nbc < 0 || nbc > MAX_CHILDREN_NUMBER){
		printf("Erro, numero de filhos excedidos\n");
		return NULL;
	}
	
	/* verifica se eh um tipo de nodo valido (299-336)*/
	if (t < 299 || t > 340){
		printf("Erro, tipo do nodo nao identificado\n");
		return NULL;
	}	
		
    /* preenche o nodo com os dados recebidos */	
	node->num_line = nl;
	node->id = __nodes_ids__;
	node->type = t;
	node->lexeme = lex;
	node->attribute = att;
	node->num_children = nbc;
	node->children = children;			
	
	__nodes_ids__++;
	
	return node;
}



Node* create_leaf(int nl, Node_type t, char* lex, void* att) {
	
	/* verifica se eh um tipo de nodo valido (299-336)*/
	if (t < 299 || t > 340){
		printf("Erro, tipo do nodo nao identificado\n");
		return NULL;
	}	
			
    	/* aloca memoria para um nodo novo */
	Node* node = calloc(1,sizeof(Node));
	
	/* preenche o nodo com os dados recebidos */
	node->num_line = nl;
	node->id = __nodes_ids__;
	node->type = t;
	node->lexeme = lex;
	node->attribute = att;
	node->num_children = 0;
	node->children = NULL;
	
	__nodes_ids__++;
	
	return node;
}


int nb_of_children(Node* n) {
   
   /* verifica se o nodo nao eh NULL */
   if (n == NULL) {
	   printf("Error, node is NULL (nb_of_children)\n");
	   return -1;
   }
   
   return n->num_children;
}



Node* child(Node* n, int i) {
  
   /* verifica se o nodo nao eh NULL */
   if (n == NULL) {
	   printf("Error, node is NULL (child)\n");
	   return NULL;
   }
   
   /* verifica se o filho procurado eh valido */
   if (i <= 0 || i > n->num_children){
	   printf("Error, node don't have the %d children\n", i);
	   return NULL; 
   }
   
   /* retorna o i-esimo filho de n */
   return n->children[i-1];  
}


int deep_free_node(Node* n) {
	int i;
	  
	/* chama recursivamente e vai desalocando */
	for (i=0; i < n->num_children; i++){
		deep_free_node(n->children[i]);
	}

	free(n);
	  
	return 0; 
}



int height(Node *n) {
	int i,b=0;
	int maxheight=0;
	
	/* se o nodo for folha */
	if (n->num_children==0){
		return 1;
	}	
	
	/* coloca em maxheight o maior caminho */
	for (i=0; i < n->num_children; i++){
		if ( (b = height(n->children[i])+1) > maxheight ){
			maxheight = b;
		}
	}	
	
	return maxheight;
}


int pack_nodes(Node*** array_of_nodes, const int cur_size, Node* n) {

	/* nao pode ter mais filhos do que o maximo permitido */
	if (cur_size > MAX_CHILDREN_NUMBER){
		printf("Error, exceded max number of children per node\n");
		return -1;
	}
	
	/* na primeira vez aponta o array de nodos para NULL */
	if (cur_size==0){
		(*array_of_nodes) = NULL;
	}
	
	/* se o array de nodos for NULL cria um novo espaco de memoria,
	 * caso contrario extende o espaco ja alocado anteriormente e insere n na ultima posicao */
	(*array_of_nodes) = realloc(*array_of_nodes, (cur_size+1)*sizeof(Node*));	
	(*array_of_nodes)[cur_size] = n;
	
	return cur_size+1;
}

/* Imprime a árvore */
void print_tree(Node* n){
	if (nb_of_children(n) == 0){
		/* cria e insere uma nova entrada na tabela */
		printf("%s ", n->lexeme);	
	}
	else {
		int i;
		
		for (i=1; i <= nb_of_children(n); i++){
			print_tree(child(n,i));
			/*if (i == nb_of_children(n)) printf(" \n");*/
		}
		printf(" [%s] \n", n->lexeme);
		
	}
}

