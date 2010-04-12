#include "lista.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#ifndef _LISTA_C_
#define _LISTA_C_

struct tac* create_inst_tac(const char* res, const char* arg1,
                 const char* op, const char* arg2) {
   struct tac * t = (struct tac *)malloc(sizeof(struct tac));
   t->op = (char*)malloc(sizeof(char)*(1+strlen(op)));
   strcpy(t->op, op);
   t->res = (char*)malloc(sizeof(char)*(1+strlen(res)));
   strcpy(t->res, res);
   t->arg1 = (char*)malloc(sizeof(char)*(1+strlen(arg1)));
   strcpy(t->arg1, arg1);
   t->arg2 = (char*)malloc(sizeof(char)*(1+strlen(arg2)));
   strcpy(t->arg2, arg2);
   printf("tac created with success: %s\t:= %s %s %s\n", t->res, t->arg1, t->op, t->arg2);
   return( t );
}

void print_inst_tac(FILE* out, struct tac i) {
   fprintf(out, "%s\t:= %s %s %s\n", i.res, i.arg1, i.op, i.arg2);
}

/* A IMPLEMENTAR */
void print_tac(FILE* out, struct node_tac * code) {
  /* A IMPLEMENTAR */
  int i = 0;
  struct node_tac * actual;
  printf("Printing\n");
  actual = code;
  while (actual!=NULL){
      i++;
      printf("%d \n",i);
      print_inst_tac(out, *actual->inst); //print_inst_tac recebe um ponteiro para arquivo e uma struct tac (não um ponteiro);
      actual = actual->next;
  }
  printf("Finished printing\n");
}

void append_inst_tac(struct node_tac ** code_ref, struct tac * inst) {
  /* A IMPLEMENTAR */
  printf("Append\n");

  /* Aloca memória para novo nodo */
  struct node_tac * novo = (struct node_tac *)malloc(sizeof(struct node_tac));
  novo->inst = inst;
  novo->next = NULL;

  struct node_tac * temp = *code_ref;  //utilizado para percorrer a lista
  struct node_tac * begin = *code_ref; //utilizado para guardar o início da lista

  /* Caso a lista seja vazia */
  if (temp==NULL){
      printf("lista vazia\n");
      novo->prev = NULL;               //no início da lista o anterior é NULL
      *code_ref = novo;                //o primeiro elemento é o novo
      printf("criado com sucesso\n");
  }
  else {
      printf("lista nao vazia\n");
      struct node_tac * last;
      while (temp!=NULL){              //percorre a lista até o fim
          novo->prev = temp;           //o anterior é o último da lista
          last = temp;                 //guarda o último da lista
          temp = temp->next;
          printf("percorrendo a lista\n");
      }
      last->next = novo;               //atualiza o ponteiro next do último da lista
      *code_ref = begin;               //atualiza o início da lista
  }
  printf("Append with sucess\n");
}

void cat_tac(struct node_tac ** code_a, struct node_tac ** code_b) {
  /* A IMPLEMENTAR */
    struct node_tac * begin = *code_a;
  /* se a code_a for vazia*/
    if (*code_a==NULL) *code_a = *code_b;
    else {
        struct node_tac * temp = *code_a;
        while (temp->next!=NULL){
            temp = temp->next;
        }
        temp->next = *code_b;
        (*code_b)->prev = temp;
    }
    *code_a = begin;
}

#endif
