#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#include "symbol_table.h"



char randChar(){
	return (rand()%25) + 97;
}

int main(int argc, char *argv[])
{
	entry_t_list* list = NULL;
	
	char teste[1000][12];
	int i, j;
	entry_t* eteste;
	
 	symbol_t st;
	init_table(&st);
	
	 FILE * myFile;
     myFile = fopen("teste.txt","w");

	
	srand(time(NULL));
	for(i=0; i < 100; i++)
	{
		eteste = calloc(1,sizeof(entry_t));
		
		for(j = 0; j < 10; j++)
  			teste[i][j] = randChar();
	
		teste[i][j] = '\0';
		eteste->name = &teste[i];
  		insert(&st,eteste);
 	}
 	// testa tabela
	for(i=0; i < 100; i++)
	{
		if( !strcpy(lookup(st,&teste[i])->name, &teste[i]) )
			printf("erro!");
 	}
	
	
	/*
 	entry_t* one = calloc(1,sizeof(entry_t));
	char hello[] = "hello";
	one->name = hello;
	one->type = 12;
	
	entry_t* two = calloc(1,sizeof(entry_t));
	char world[] = "world";
	two->name = world;
	two->type = 13;
	
	symbol_t st;
	init_table(&st);

	printf("teste \n");
	insert(&st,one);
	insert(&st,two);
	
	printf("%s ..", lookup(st,"hello")->name);
	printf("%s \n", lookup(st,"world")->name);
	
	print_table(st);
	
	free_table(&st);
	
 */
 	//printf(" \n tamanho: %d", print_table(st));
	//print_file_table(myFile, st);
	fclose (myFile);
 	free_table(&st);
    char temp[100];
	scanf("%s", temp); 
	return 0;
}
