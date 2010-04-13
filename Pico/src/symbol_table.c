#include "symbol_table.h"

/* lista
	essa lista é uma estrutura de dados auxiliar para a tabela hash
 */
entry_t* entry_t_lookup(entry_t_list* list, char* c){
	entry_t_list* temp = list;
	
	while( temp != NULL){
		if(strcmp(c, temp->data->name) == 0)
			break;
		temp = temp->next;
	}
	
	return temp->data;
}

int entry_t_list_insert(entry_t_list** list, entry_t* entry){
	entry_t_list* temp = *list, * current;
	
	if( temp == NULL)
	{
		
		(*list) = calloc(1, sizeof(entry_t_list));
		if( *list == NULL)
			return -1;
		(*list)->data = entry;
		(*list)->next = NULL;
	}
 	else{
		while( temp->next != NULL)
			temp = temp->next;
   		temp->next = current = calloc(1, sizeof(entry_t_list));
   		if(current == NULL)
   			return -1;
		current->data = entry;
		current->next = NULL;
    }
    
    return 0;
}
void entry_t_erase_all(entry_t_list** list){
	entry_t_list* temp = *list, * current;
	
	if( temp == NULL)
	{
		return;
	}
 	else{
		do{
			current = temp;
			temp = temp->next;
			
			free(current->data);
			free(current);
		}while( temp != NULL);
   	}
}

/* hash table */

int hashpjw(char *s){
	char* p;
	unsigned h = 0, g;
	for( p = s; *p != EOS; p += 1){
		h = (h << 4) + (*p);
		if( g = h&0xf0000000 ) {
			h = h ^ ( g >> 24);
			h = h ^g;
		}
	}
	return h % ST_SIZE;
}

int init_table(symbol_t* table){
	int i;
	for( i = 0; i < ST_SIZE; i++)
		table->table[i] = NULL;
	
	return 1;
}
void free_table(symbol_t* table){
	int i;
	for( i = 0; i < ST_SIZE; i++)
		entry_t_erase_all(&table->table[i]) ;
}

int insert(symbol_t* table, entry_t* entry){
	int bucket = hashpjw(entry->name);
	
	return entry_t_list_insert(&table->table[bucket],entry);
}

entry_t* lookup(symbol_t table, char* name){
	int bucket = hashpjw(name);
	
	return entry_t_lookup(table.table[bucket], name); 
}
int print_table(symbol_t table){
	entry_t_list* temp;
	int i, total_items = 0;
	for( i = 0; i < ST_SIZE; i++)
		if( table.table[i] != NULL )
		{
			temp = table.table[i];
			while( temp != NULL){
				total_items++;
				printf("%s ", temp->data->name);
				temp = temp->next;
   			}
			printf("\n");
		}
	printf("total : %d", total_items);
	return total_items;
}

int print_file_table(FILE* out, symbol_t table){
	entry_t_list* temp;
	int i, total_items = 0;
	for( i = 0; i < ST_SIZE; i++)
		if( table.table[i] != NULL )
		{
			temp = table.table[i];
			while( temp != NULL){
				total_items++;
				fprintf(out, "%s ", temp->data->name);
				temp = temp->next;
   			}
			fprintf(out, "\n");
		}
	fprintf(out, "total : %d", total_items);
	return total_items;
}
