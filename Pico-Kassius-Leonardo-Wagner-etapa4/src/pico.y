%{
  /* Aqui, pode-se inserir qualquer codigo C necessario ah compilacao
   * final do parser. Sera copiado tal como esta no inicio do y.tab.c
   * gerado por Yacc.
   */
  #include <stdio.h>
  #include <stdlib.h>
  #include "node.h"
  #include "symbol_table.h"
  
  /* macro pra concatenar as partes em str*/
  #define CAT(str,B,C,D) strcat(strcat(strcpy(str, B), C), D)

  /*árvore de sintaxe abstrata*/
  Node* syntax_tree;
  int lineno=1;

  /*tabela de símbolos*/
  symbol_t* s_table;
  long desloc;

  /* cabeçalho de algumas funções auxiliares */
  int size_of_type(int type);
  void insert_list_of_vars(Node* n, int var_type);

 


%}

%union {
  char* cadeia;
  struct _node* no;
}

/*tipos dos simbolos nao terminais da gramatica*/
%type< no > expr
%type< no > listadeclaracao
%type< no > lvalue
%type< no > chamaproc
%type< no > enunciado
%type< no > declaracoes
%type< no > acoes
%type< no > code
%type< no > comando
%type< no > declaracao
%type< no > tipo
%type< no > tipounico
%type< no > tipolista
%type< no > listadupla
%type< no > listaexpr
%type< no > expbool
%type< no > fiminstcontrole

/*tipos dos simbolos terminais - tokens - da gramatica*/
%token< cadeia > IDF
%token< cadeia > INT
%token< cadeia > DOUBLE
%token< cadeia > FLOAT
%token< cadeia > CHAR
%token< cadeia > QUOTE
%token< cadeia > DQUOTE
%token< cadeia > LE
%token< cadeia > GE
%token< cadeia > EQ
%token< cadeia > NE
%token< cadeia > AND
%token< cadeia > OR
%token< cadeia > NOT
%token< cadeia > IF
%token< cadeia > THEN
%token< cadeia > ELSE
%token< cadeia > WHILE
%token< cadeia > INT_LIT
%token< cadeia > F_LIT
%token< cadeia > END
%token< cadeia > TRUE
%token< cadeia > FALSE
%token FOR
%token NEXT
%token UNTIL
%token REPEAT
%start code

%right '='
%left '+' '-'
%left '*' '/'
%left AND OR 
%left NOT

 /* A completar com seus tokens - compilar com 'yacc -d' */

%%
code: declaracoes acoes {Node** children; 
			 Node* pf1 = $1;
 			 Node* pf3 = $2; 
			 pack_nodes(&children, 0, pf1);
			 pack_nodes(&children, 1, pf3);
		syntax_tree = create_node(lineno, program_node, "raiz", NULL, 2, children);
		printf("raiz %d \n", lineno);
		printf("------------------- verificando tabela de simbolos ----------------------\n");
		print_table(*s_table);

		}
    | acoes		{$$ = $1;}		
    ;

declaracoes: declaracao ';' 		{$$ = $1;}
           | declaracoes declaracao ';'	{Node** children; 
			 		 Node* pf1 = $1;
 			 		 Node* pf3 = $2; 
			 		 pack_nodes(&children, 0, pf1);
			 		 pack_nodes(&children, 1, pf3);
		$$ = create_node(lineno, decl_node, "declaracoes", NULL, 2, children);
		printf("declaracoes %d \n", lineno);}
           ;

declaracao: listadeclaracao ':' tipo {	Node** children; 
			 		Node* pf1 = $1;
 			 		Node* pf3 = $3; 
			 		pack_nodes(&children, 0, pf1);
			 		pack_nodes(&children, 1, pf3);

					/* insere as variaveis na lista de simbolos */
					insert_list_of_vars($1, $3->type);					
		
					$$ = create_node(lineno, decl_node, "declaracao", NULL, 2, children);
					printf("declaracao %d \n", lineno);}


listadeclaracao: IDF {	Node* n = create_leaf(lineno, idf_node, $1, NULL);  
			$$ = n;}
               | IDF ',' listadeclaracao { Node** children;
					  Node* pf1 = create_leaf(lineno, idf_node, $1, NULL); 
					  Node* pf3 = $3; 
					  pack_nodes(&children, 0, pf1);
					  pack_nodes(&children, 1, pf3);
					  $$ = create_node(lineno, decl_list_node, "lista", NULL, 2, children);
					  printf("lista declaracao %s , %s, %d \n", $1, $3->lexeme,lineno);
					}
               ;

tipo: tipounico { $$ = $1; }
    | tipolista { $$ = $1; }
    ;

tipounico: INT { Node* n = create_leaf(lineno, int_node, $1, NULL); 
		 $$ = n; }
         | DOUBLE { Node* n = create_leaf(lineno, double_node, $1, NULL); 
		 $$ = n; }
         | FLOAT { Node* n = create_leaf(lineno, float_node, $1, NULL); 
		 $$ = n; }
         | CHAR { Node* n = create_leaf(lineno, char_node, $1, NULL); 
		 $$ = n; }
         ;

tipolista: INT '[' listadupla ']' 
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, int_node, $1, NULL); 
		  Node* pf3 = $3; 
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "tipolista", NULL, 2, children);
		  printf("tipolista %s , %s, %d \n", $1, $3->lexeme, lineno);
		}
         | DOUBLE '[' listadupla ']'
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, float_node, $1, NULL); 
		  Node* pf3 = $3; 
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "tipolista", NULL, 2, children);
		  printf("tipolista %s , %s, %d \n", $1, $3->lexeme, lineno);
		}
         | FLOAT '[' listadupla ']'
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, float_node, $1, NULL); 
		  Node* pf3 = $3; 
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "tipolista", NULL, 2, children);
		  printf("tipolista %s , %s, %d \n", $1, $3->lexeme, lineno);
		}
         | CHAR '[' listadupla ']'
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, char_node, $1, NULL); 
		  Node* pf3 = $3; 
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "tipolista", NULL, 2, children);
		  printf("tipolista %s , %s, %d \n", $1, $3->lexeme, lineno);
		}
         ;

listadupla: INT_LIT ':' INT_LIT
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, int_node, $1, NULL); 
		  Node* pf3 = create_leaf(lineno, int_node, $3, NULL);
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "listadupla", NULL, 2, children);
		  printf("listadupla %s , %s, %d \n", $1, $3, lineno);
		}
          | INT_LIT ':' INT_LIT ',' listadupla
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, int_node, $1, NULL); 
		  Node* pf2 = create_leaf(lineno, int_node, $3, NULL);
		  Node* pf3 = $5;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, decl_list_node, "listadupla", NULL, 3, children);
		  printf("listadupla %s , %s, %s, %d \n", $1, $3, $5->lexeme, lineno);
		}
          ;

acoes: comando ';' { $$ = $1; }
    | comando ';' acoes 
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "acoes", NULL, 2, children);
		  printf("acoes %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
    ;

comando: lvalue '=' expr 
		{ printf("%s \n",$3->lexeme);
		  Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "comando", NULL, 2, children);
		  printf("acoes %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
       | enunciado 	 { $$ = $1; }
       ;

lvalue: IDF { 	Node* n = create_leaf(lineno, idf_node, $1, NULL); 
		$$ = n; }
      | IDF '[' listaexpr ']'
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, idf_node, $1, NULL); 
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, idf_node, "lvalue", NULL, 2, children);
		  printf("lvalue %s , %s, %d \n", $1, $3->lexeme, lineno);
		}
      ;

listaexpr: expr { $$ = $1; }
	   | expr ',' listaexpr
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, op_node, "listaexpr", NULL, 2, children);
		  printf("listaexpr %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
	   ;

expr: expr '+' expr  {  char* str = calloc(strlen($1->lexeme)+strlen($3->lexeme)+2, sizeof(char*));
			CAT(str,$1->lexeme,$3->lexeme,"+");
			Node** children; 
			Node* pf1 = $1;
 			Node* pf3 = $3; 
			pack_nodes(&children, 0, pf1);
			pack_nodes(&children, 1, pf3);
			$$ = create_node(lineno, 305, str, NULL, 2, children);
			printf("node: %s\n", str);}
    | expr '-' expr  { 	char* str = calloc(strlen($1->lexeme)+strlen($3->lexeme)+2, sizeof(char*)); 
			CAT(str,$1->lexeme,$3->lexeme,"-");
			Node** children; 
			Node* pf1 = $1;
 			Node* pf3 = $3; 
			pack_nodes(&children, 0, pf1);
			pack_nodes(&children, 1, pf3);
			$$ = create_node(lineno, 305, str, NULL, 2, children);
			printf("node: %s\n", str);}
    | expr '*' expr  { 	char* str = calloc(strlen($1->lexeme)+strlen($3->lexeme)+2, sizeof(char*)); 
			CAT(str,$1->lexeme,$3->lexeme,"*");
			Node** children; 
			Node* pf1 = $1;
 			Node* pf3 = $3; 
			pack_nodes(&children, 0, pf1);
			pack_nodes(&children, 1, pf3);
			$$ = create_node(lineno, op_node, str, NULL, 2, children);
			printf("node: %s\n", str);}
    | expr '/' expr  { 	char* str = calloc(strlen($1->lexeme)+strlen($3->lexeme)+2, sizeof(char*)); 
			CAT(str,$1->lexeme,$3->lexeme,"/");
			Node** children; 
			Node* pf1 = $1;
 			Node* pf3 = $3; 
			pack_nodes(&children, 0, pf1);
			pack_nodes(&children, 1, pf3);
			$$ = create_node(lineno, op_node, str, NULL, 2, children); 
			printf("node: %s\n", str);}
    | '(' expr ')'   { 	$$ = $2; }
    | INT_LIT 	     { 	Node* n = create_leaf(lineno, int_node, $1, NULL); 
		       	$$ = n;}
    | F_LIT    	     { 	Node* n = create_leaf(lineno, float_node, $1, NULL); 
		       	$$ = n;}
    | lvalue         {  $$ = $1;}
    | chamaproc      {	$$ = $1;}
    ;

chamaproc: IDF '(' listaexpr ')'
		{Node** children; 
		 Node* pf1 = create_leaf(lineno, idf_node, $1, NULL);
 		 Node* pf3 = $3; 
		 pack_nodes(&children, 0, pf1);
		 pack_nodes(&children, 1, pf3);
		 $$ = create_node(lineno, proc_node, "chamaproc", NULL, 2, children); 
		 printf("chamaproc %s, %s \n", $1, $3->lexeme);}
         ;

enunciado: expr   { $$ = $1; printf("%s \n",$1->lexeme);}
         | IF '(' expbool ')' THEN acoes fiminstcontrole
		{Node** children; 
		 Node* pf1 = create_leaf(lineno, if_node, $1, NULL);
 		 Node* pf2 = $3;
		 Node* pf3 = create_leaf(lineno, cond_node, $5, NULL); 
		 Node* pf4 = $6; 
		 Node* pf5 = $7; 
		 pack_nodes(&children, 0, pf1);
		 pack_nodes(&children, 1, pf2);
		 pack_nodes(&children, 2, pf3);
		 pack_nodes(&children, 3, pf4);
		 pack_nodes(&children, 4, pf5);
		 $$ = create_node(lineno, cond_node, "enunciado", NULL, 5, children); 
		 printf("enunciado %s, %s \n", $1, $5);}
         | WHILE '(' expbool ')' '{' acoes '}'
		{Node** children; 
		 Node* pf1 = create_leaf(lineno, while_node, $1, NULL);
 		 Node* pf2 = $3;
		 Node* pf3 = $6; 
		 pack_nodes(&children, 0, pf1);
		 pack_nodes(&children, 1, pf2);
		 pack_nodes(&children, 2, pf3);
		 $$ = create_node(lineno, cond_node, "enunciado", NULL, 3, children); 
		 printf("enunciado %s, %s \n", $3->lexeme, $6->lexeme);}
         ;

fiminstcontrole: END { 	Node* n = create_leaf(lineno, if_node, $1, NULL); 
		       	$$ = n;}
               | ELSE acoes END
		{Node** children; 
		 Node* pf1 = create_leaf(lineno, if_node, $1, NULL);
 		 Node* pf2 = $2;
		 Node* pf3 = create_leaf(lineno, if_node, $3, NULL);
		 pack_nodes(&children, 0, pf1);
		 pack_nodes(&children, 1, pf2);
		 pack_nodes(&children, 2, pf3);
		 $$ = create_node(lineno, proc_node, "fiminstcontrole", NULL, 3, children); 
		 printf("fiminstcontrole %s, %s \n", $1, $3);}
               ;

expbool: TRUE { 	Node* n = create_leaf(lineno, true_node, $1, NULL); 
		       	$$ = n;}
       | FALSE { 	Node* n = create_leaf(lineno, false_node, $1, NULL); 
		       	$$ = n;}
       | '(' expbool ')' { $$ = $2;}
       | expbool AND expbool
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf2 = create_leaf(lineno, and_node, $2, NULL);
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, cond_node, "expbool", NULL, 3, children);
		  printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
       | expbool OR expbool
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf2 = create_leaf(lineno, or_node, $2, NULL);
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, cond_node, "expbool", NULL, 3, children);
		  printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
       | NOT expbool
		{ Node** children; 
		  Node* pf1 = create_leaf(lineno, not_node, $1, NULL);
		  Node* pf2 = $2;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  $$ = create_node(lineno, cond_node, "expbool", NULL, 2, children);
		  printf("expbool %s , %s, %d \n", $1, $2->lexeme, lineno);
		}
       | expr '>' expr
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf2 = create_leaf(lineno, sup_node, ">", NULL);
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, cond_node, "expbool", NULL, 3, children);
		  printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
       | expr '<' expr
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf2 = create_leaf(lineno, inf_node, "<", NULL);
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, cond_node, "expbool", NULL, 3, children);
		  printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
       | expr LE expr
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf2 = create_leaf(lineno, inf_eq_node, $2, NULL);
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, cond_node, "expbool", NULL, 3, children);
		  printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
       | expr GE expr
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf2 = create_leaf(lineno, sup_eq_node, $2, NULL);
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, cond_node, "expbool", NULL, 3, children);
		  printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
       | expr EQ expr
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf2 = create_leaf(lineno, eq_node, $2, NULL);
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, cond_node, "expbool", NULL, 3, children);
		  printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
       | expr NE expr
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf2 = create_leaf(lineno, eq_node, $2, NULL);
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, cond_node, "expbool", NULL, 3, children);
		  printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);
		}
       ;
%%
 /* A partir daqui, insere-se qlqer codigo C necessario.
  */



/*função que verifica se a extensão do arquivo é .pico
 *retorna 0 caso seja
 *ou retorna -1 caso os últimos caracteres do nome do arquivo não sejam .pico
 */
int validExtension(char* s){
  int length = strlen(s);
  if (length < 5) return -1;
  if ((s[length-1] == 'o')&&(s[length-2] == 'c')&&
      (s[length-3] == 'i')&&(s[length-4] == 'p')&&(s[length-5] == '.'))
  	return 0;
  else return -1;
}

 /* funcao recursiva que percorre os nodos e vai colocando as variaveis na
     tabela de simbolos */
void insert_list_of_vars(Node* n, int var_type)
{
	if (nb_of_children(n) == 0){
		//printf( "variavel: %s \n", n->lexeme);
		/* cria e insere uma nova entrada na tabela */
		entry_t* var = malloc(sizeof(entry_t));	
		var->name = n->lexeme;
		var->type = var_type;	
		var->size = size_of_type(var_type);
		insert(s_table, var); 	
	}
	else {
		int i;
		for (i=1; i <= nb_of_children(n); i++)
			insert_list_of_vars(child(n,i), var_type);
	}
}

/* retorna o tamanho do tipo */
int size_of_type(int type)
{
	switch(type)
	{
	case int_node:
		return 4;
	case float_node:
		return 4;
	case char_node:
		return 1;
	case double_node:
		return 8;
	}
	return 0;
}



char* progname;
extern FILE* yyin;

int main(int argc, char* argv[]) 
{
   /*inicializa deslocamento para declaração de variáveis*/
   desloc = 0;

   /*inicializa tabela de símbolos*/
   s_table = malloc(sizeof(symbol_t));					
   init_table(s_table);

   if (argc != 2) {
     printf("uso: %s <input_file>. Try again!\n", argv[0]);
     exit(-1);
   }

   if (validExtension(argv[1]) != 0){
     printf("Invalid Extension, the input file must have .pico extension\n");
     exit(-1);
   }

   yyin = fopen(argv[1], "r");
   if (!yyin) {
     printf("Uso: %s <input_file>. Could not find %s. Try again!\n", 
         argv[0], argv[1]);
     exit(-1);
   }

   progname = argv[0];

   if (!yyparse()) 
      printf("OKAY.\n");
   else 
      printf("ERROR.\n");

   return(0);
}

yyerror(char* s) {
  fprintf(stderr, "%s: %s", progname, s);
  fprintf(stderr, "line %d\n", lineno);
}
