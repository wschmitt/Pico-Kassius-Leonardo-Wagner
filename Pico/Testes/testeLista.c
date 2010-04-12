#include "lista.h"

int main(){
    FILE * pFile;
    pFile = fopen ("myfile.txt","w");
    if (pFile!=NULL)
    {
        struct node_tac *lista = NULL;
        append_inst_tac(&lista, create_inst_tac("Kassius", "Leonardo", "Wagner", "etapa2"));
        append_inst_tac(&lista, create_inst_tac("Prestes", "Moura", "Schmitd", "etapa2"));
        append_inst_tac(&lista, create_inst_tac("3", "3", "3", "3"));
        append_inst_tac(&lista, create_inst_tac("4", "4", "4", "4"));
        append_inst_tac(&lista, create_inst_tac("5", "5", "5", "5"));

        struct node_tac *lista2 = NULL;
        append_inst_tac(&lista2, create_inst_tac("Kassius", "Leonardo", "Wagner", "etapa2"));
        append_inst_tac(&lista2, create_inst_tac("Prestes", "Moura", "Schmitd", "etapa2"));
        append_inst_tac(&lista2, create_inst_tac("3", "3", "3", "3"));
        append_inst_tac(&lista2, create_inst_tac("4", "4", "4", "4"));
        append_inst_tac(&lista2, create_inst_tac("5", "5", "5", "5"));

        append_inst_tac(&lista, create_inst_tac("6", "6", "6", "6"));
        append_inst_tac(&lista2, create_inst_tac("6", "6", "6", "6"));
        append_inst_tac(&lista, create_inst_tac("7", "7", "7", "7"));
        append_inst_tac(&lista2, create_inst_tac("7", "7", "7", "7"));
        append_inst_tac(&lista, create_inst_tac("8", "8", "8", "8"));
        append_inst_tac(&lista2, create_inst_tac("8", "8", "8", "8"));
        append_inst_tac(&lista, create_inst_tac("9", "9", "9", "9"));
        append_inst_tac(&lista2, create_inst_tac("9", "9", "9", "9"));

        struct node_tac *lista3 = NULL;
        append_inst_tac(&lista3, create_inst_tac("lista3", "lista3", "1", "1"));
        append_inst_tac(&lista3, create_inst_tac("lista3", "lista3", "2", "2"));
        append_inst_tac(&lista3, create_inst_tac("lista3", "lista3", "3", "3"));
        append_inst_tac(&lista3, create_inst_tac("lista3", "lista3", "4", "4"));
        append_inst_tac(&lista3, create_inst_tac("lista3", "lista3", "5", "5"));

        cat_tac(&lista, &lista3);
        cat_tac(&lista, &lista2);
/*
        struct node_tac * t1;
        //struct node_tac * t2;
        t1->inst = create_inst_tac("Kassius", "Leonardo", "Wagner", "etapa2");
        t1->prev = NULL;
        t1->next = NULL;

        printf("lalalalla");
        getchar();

        append_inst_tac(&t1, create_inst_tac("Prestes", "Moura", "Schmitd", "etapa2"));
        append_inst_tac(&t1, create_inst_tac("3", "3", "3", "3"));
        append_inst_tac(&t1, create_inst_tac("4", "4", "4", "4"));
        append_inst_tac(&t1, create_inst_tac("5", "5", "5", "5"));
        //t2->inst = create_inst_tac("Prestes", "Moura", "Schmitd", "etapa2");
        //t2->prev = NULL;
        //t2->next = NULL;
*/
        printf("lalalalla");
        getchar();

        print_tac(pFile, lista);

        fclose (pFile);
    }
    return 0;
}
