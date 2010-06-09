%{
  /* Aqui, pode-se inserir qualquer codigo C necessario ah compilacao
   * final do parser. Sera copiado tal como esta no inicio do y.tab.c
   * gerado por Yacc.
   */
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "node.h"
  #include "symbol_table.h"
  #include "lista.h"

  #define UNDEFINED_SYMBOL_ERROR -21
  #define ARRAY_INDEXES_ERROR -35

  #define LIT 124
  #define DUPLA 125

   typedef struct 
   {
	int ndim;
	int c[100];
	int size_of_type;
	int lim_inf[100];
	int lim_sup[100];
   } t_array;
 
   typedef struct
   {
    struct node_tac* code;
    char* correct;
    char* wrong;
   } t_boolexp;

   typedef struct
   {
    struct node_tac* code;
   } t_exp;

   typedef struct
   {
    struct node_tac* code;	
    char* idf;
   } t_exp_ar;

  /* macro pra concatenar as partes em str*/
  #define CAT(str,B,C,D) strcat(strcat(strcpy(str, B), C), D)

  /*árvore de sintaxe abstrata*/
  Node* syntax_tree;
  int lineno=1;

  /*tabela de símbolos*/
  symbol_t* s_table;
  long desloc = 0;
  long desloc_tmp = 0;

  /*lista de instruções*/
  struct node_tac* l_inst = NULL;
  int proxima_inst = 0;

  /* cabeçalho de algumas funções auxiliares */
  char* createTmp();
  char* createLbl(); 
  char* substr(char* fonte, int pos_i, int pos_f);
  int size_of_type(int type);
  void insert_list_of_vars(Node* n, int var_type);
  void insert_list_of_arrays(Node* n, int var_type, t_array* a);
  char* processa_arg(char* s, int line);
  t_boolexp* create_expbool(struct node_tac* _code, char* _c, char* _w);
  void verify_bool_exp(Node* node, char* _true, char* _false);
  void op_bool(Node* node, char* _true, char* _false);

%}

%union {
  char* cadeia;
  struct _node* no;
}

/*tipos dos simbolos nao terminais da gramatica*/
%type< no > expr
%type< no > listadeclaracao
%type< no > lvalue
%type< no > rvalue
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
%token< cadeia > REAL
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
%token< cadeia > PRINTF
%token FOR
%token NEXT
%token UNTIL
%token REPEAT
%start code

%right '='
%left '+' '-'
%left '*' '/'
%left OR
%left AND
%left NOT

 /* A completar com seus tokens - compilar com 'yacc -d' */

%%
code: declaracoes acoes {
			Node** children; 
			Node* pf1 = $1;
 			Node* pf3 = $2; 
			pack_nodes(&children, 0, pf1);
			pack_nodes(&children, 1, pf3);
			syntax_tree = create_node(lineno, program_node, "raiz", $2->attribute, 2, children);
			cat_tac(&l_inst, &((t_exp*)($2->attribute))->code);
			 			
			/*printf("raiz %d \n", lineno);
			printf("------------------- verificando tabela de simbolos ----------------------\n");
			print_table(*s_table);*/
		}
    | acoes		{ 
			/*Node** children; 
			Node* pf1 = $1;
			pack_nodes(&children, 0, pf1);
			syntax_tree = create_node(lineno, program_node, "raiz", NULL, 2, children);*/
			syntax_tree = create_node(lineno, program_node, "raiz", $1->attribute, 1, &$1);
			cat_tac(&l_inst, &((t_exp*)($1->attribute))->code);
			/*syntax_tree = $1;*/
		}		
    ;

declaracoes: declaracao ';' 		{$$ = $1;}
           | declaracoes declaracao ';'	{Node** children; 
			 		 Node* pf1 = $1;
 			 		 Node* pf3 = $2; 
			 		 pack_nodes(&children, 0, pf1);
			 		 pack_nodes(&children, 1, pf3);
		$$ = create_node(lineno, decl_node, "declaracoes", NULL, 2, children);
		/*printf("declaracoes %d \n", lineno);*/}
           ;

declaracao: listadeclaracao ':' tipo {	Node** children; 
			 		Node* pf1 = $1;
 			 		Node* pf3 = $3; 
			 		pack_nodes(&children, 0, pf1);
			 		pack_nodes(&children, 1, pf3);

					
					/* verifica se eh uma array */
					if (nb_of_children($3)==0)	
						/* insere as variaveis na lista de simbolos */		
						insert_list_of_vars($1, $3->type);  
					else{
						/* arrays */
						/* printf("Botou na ST\n"); */
						t_array* a = malloc(sizeof(t_array));

						int i = 0;
						Node* temp = child($3,2);
						while((int)temp->attribute == DUPLA){
							a->lim_inf[i] = atoi(child(temp,1)->lexeme);
							a->lim_sup[i] = atoi(child(temp,2)->lexeme);
							temp = child(temp,3);
							i++;
						}
						a->ndim = i+1;
						a->lim_inf[i] = atoi(child(temp,1)->lexeme);
						a->lim_sup[i] = atoi(child(temp,2)->lexeme);

						/* preenche o c */
						a->c[i] = 1;		
						while( i > 0 ) {
							i--;
							/* acumula o tamanho da array */
							a->c[i] = (a->lim_sup[i+1] - a->lim_inf[i+1]) * a->c[i+1]; 
							printf("%i : %d %d %d\n", i, a->lim_sup[i+1],a->lim_inf[i+1], a->c[i]); 	
						}
	
						//a->lim_inf[0] = atoi(child(child($3,2),1)->lexeme);
						//printf("limite inferior %s\n", child(child($3,2),1)->lexeme);
						//a->lim_sup[0] = atoi(child(child($3,2),2)->lexeme);
						//printf("limite superior %s\n", child(child($3,2),2)->lexeme);
						insert_list_of_arrays($1,child($3,1)->type,a);
						/*printf("nodo da array: %s \n", child(child($3,2),1)->lexeme);*/
					}					
		
					$$ = create_node(lineno, decl_node, "declaracao", NULL, 2, children);
					/*printf("declaracao %d \n", lineno);*/}



listadeclaracao: IDF {	Node* n = create_leaf(lineno, idf_node, $1, NULL);  
			$$ = n;}
               | IDF ',' listadeclaracao { Node** children;
					  Node* pf1 = create_leaf(lineno, idf_node, $1, NULL); 
					  Node* pf3 = $3; 
					  pack_nodes(&children, 0, pf1);
					  pack_nodes(&children, 1, pf3);
					  $$ = create_node(lineno, decl_list_node, "lista", NULL, 2, children);
					  /*printf("lista declaracao %s , %s, %d \n", $1, $3->lexeme,lineno);*/
					}
               ;

tipo: tipounico { $$ = $1; }
    | tipolista { $$ = $1; }
    ;

tipounico: INT { Node* n = create_leaf(lineno, int_node, $1, NULL); 
		 $$ = n; }
         | DOUBLE { Node* n = create_leaf(lineno, double_node, $1, NULL); 
		 $$ = n; }
         | REAL { Node* n = create_leaf(lineno, real_node, $1, NULL); 
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
		  /*printf("tipolista %s , %s, %d \n", $1, $3->lexeme, lineno);*/
		}
         | DOUBLE '[' listadupla ']'
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, double_node, $1, NULL); 
		  Node* pf3 = $3; 
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "tipolista", NULL, 2, children);
		  /*printf("tipolista %s , %s, %d \n", $1, $3->lexeme, lineno);*/
		}
         | REAL '[' listadupla ']'
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, real_node, $1, NULL); 
		  Node* pf3 = $3; 
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "tipolista", NULL, 2, children);
		  /*printf("tipolista %s , %s, %d \n", $1, $3->lexeme, lineno);*/
		}
         | CHAR '[' listadupla ']'
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, char_node, $1, NULL); 
		  Node* pf3 = $3; 
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "tipolista", NULL, 2, children);
		  /*printf("tipolista %s , %s, %d \n", $1, $3->lexeme, lineno);*/
		}
         ;

listadupla: INT_LIT ':' INT_LIT
		{ 

		 /* if( atoi($1) > atoi($3) ){
			return (ARRAY_INDEXES_ERROR);
		  }*/

		  Node** children;
		  Node* pf1 = create_leaf(lineno, int_node, $1, NULL); 
		  Node* pf3 = create_leaf(lineno, int_node, $3, NULL);
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, decl_list_node, "listadupla", (void*)LIT, 2, children);
		  /*printf("listadupla %s , %s, %d \n", $1, $3, lineno);*/
		}
          | INT_LIT ':' INT_LIT ',' listadupla
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, int_node, $1, NULL); 
		  Node* pf2 = create_leaf(lineno, int_node, $3, NULL);
		  Node* pf3 = $5;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf2);
		  pack_nodes(&children, 2, pf3);
		  $$ = create_node(lineno, decl_list_node, "listadupla", (void*)DUPLA, 3, children);
		  /*printf("listadupla %s , %s, %s, %d \n", $1, $3, $5->lexeme, lineno);*/
		}
          ;

acoes: comando ';' { $$ = $1; }
    | comando ';' acoes 
		{ Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);

 		  t_exp* ex = malloc(sizeof(t_exp));
		  ex->code = NULL;
		  
		  cat_tac(&(ex->code), &((t_exp*)$1->attribute)->code);	
		  cat_tac(&(ex->code), &((t_exp*)$3->attribute)->code);
		  //ex->code = inst;
		  //printf("testeeeeeeeeee %s \n", ex->code->inst->res);		
	
		  $$ = create_node(lineno, decl_list_node, "acoes", (void*)ex, 2, children);
		  /*printf("acoes %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);*/
		}
    ;

comando: lvalue '=' expr 
		{ 
		  printf("%s  aa\n", $1->lexeme);
		  struct node_tac *inst = NULL;
		  //printf("%p lala\n",$3->attribute);
		  if ($1->attribute != NULL){ 
			printf("%s cc\n", $3->lexeme);
			cat_tac(&inst, &((t_exp_ar*)$1->attribute)->code);
			append_inst_tac(&inst, create_inst_tac($1->lexeme, ((t_exp_ar*)$1->attribute)->idf, "(", $3->lexeme));
		  }else{
		  	append_inst_tac(&inst, create_inst_tac($1->lexeme, $3->lexeme, "", ""));
			//printf("asçdlfaçsldfha\n");
			
		  }
		  printf("casacasa\n");
		
		  //printf("%p --------\n", ((t_exp*)$3->attribute)->code->next); 
		  printf("a\n");
		  //if ($3->attribute != NULL)
		  cat_tac(&((t_exp*)$3->attribute)->code, &inst);
		  //else
		  printf("b\n");
		  Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  
		  $$ = create_node(lineno, decl_list_node, "comando", $3->attribute, 2, children);
		  /*printf("acoes %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);*/
		}
       | enunciado 	 { $$ = $1; }
       ;

lvalue: IDF { 	Node* n = create_leaf(lineno, idf_node, $1, NULL); 
		$$ = n;
		/* erro de variavel nao declarada */
		if (lookup(*s_table,n->lexeme)==NULL){	
			printf("UNDEFINED SYMBOL. A variavel %s nao foi declarada.\n", n->lexeme);
			return (UNDEFINED_SYMBOL_ERROR);
		}		
	    }
      | IDF '[' listaexpr ']'
		{ 	 
		  Node** children;
		  Node* pf1 = create_leaf(lineno, idf_node, $1, NULL); 
		  Node* pf3 = $3;

		  t_exp_ar* tb = malloc(sizeof(t_exp_ar));
		  tb->code = NULL;
		  tb->idf = $1;	

		  /* erro de variavel não declarada */
		  if (lookup(*s_table,pf1->lexeme)==NULL){	
			printf("UNDEFINED SYMBOL. A variavel %s nao foi declarada.\n", pf1->lexeme);
			return (UNDEFINED_SYMBOL_ERROR);
		  }	
                  


		  t_array* array_info = (t_array*)(lookup(*s_table,$1)->extra);
		  char* tmp0 = createTmp();
		  Node* temp = $3;
		  int i = 0;

		  while(nb_of_children(temp)>1) {
			char* tmp1 = createTmp();
			char* tmp2 = ( i == 0 ) ? NULL : createTmp();
			char lim_lit[200], c_lit[200];
			sprintf(lim_lit, "%d", array_info->lim_inf[i]);
			sprintf(c_lit, "%d", array_info->c[i]);

			printf("%s\n", child(temp,1)->lexeme);
			append_inst_tac(&(tb->code), create_inst_tac(tmp1, child(temp,1)->lexeme, "SUB", lim_lit));
			if( i == 0) {
				append_inst_tac(&(tb->code), create_inst_tac(tmp0, tmp1, "MUL", c_lit));
			} else {
				append_inst_tac(&(tb->code), create_inst_tac(tmp2, tmp1, "MUL", c_lit));
				append_inst_tac(&(tb->code), create_inst_tac(tmp0, tmp0, "ADD", tmp2));
			}
			temp = child(temp,2);
			i++;
			if( i > array_info->ndim)
				printf("erro de dimensoes\n");
		  }
		 
		  char lim_lit[200], s_type[200];
		  sprintf(lim_lit, "%d", array_info->lim_inf[i]);
		  sprintf(s_type, "%d", array_info->size_of_type);
		   	
		  if( i > 0){
			  char* tmp1 = createTmp();
			  append_inst_tac(&(tb->code), create_inst_tac(tmp1, temp->lexeme, "SUB", lim_lit));
			  append_inst_tac(&(tb->code), create_inst_tac(tmp0, tmp0, "ADD", tmp1));
		  }else{
			  append_inst_tac(&(tb->code), create_inst_tac(tmp0, temp->lexeme, "SUB", lim_lit));
		  }
		  append_inst_tac(&(tb->code), create_inst_tac(tmp0, tmp0, "MUL", s_type));
		

		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);	
		  $$ = create_node(lineno, idf_node, tmp0, (void*)tb, 2, children);
		

		}
      ;

rvalue: IDF { 	t_exp* te = malloc(sizeof(t_exp));
				Node* n = create_leaf(lineno, idf_node, $1, te); 
				$$ = n;
		/* erro de variavel nao declarada */
		if (lookup(*s_table,n->lexeme)==NULL){	
			printf("UNDEFINED SYMBOL. A variavel %s nao foi declarada.\n", n->lexeme);
			return (UNDEFINED_SYMBOL_ERROR);
		}		
	    }
      | IDF '[' listaexpr ']'
		{ Node** children;
		  Node* pf1 = create_leaf(lineno, idf_node, $1, NULL); 
		  Node* pf3 = $3;

		  t_exp_ar* tb = malloc(sizeof(t_exp_ar));
		  tb->code = NULL;
		  tb->idf = $1;	

		  /* erro de variavel não declarada */
		  if (lookup(*s_table,pf1->lexeme)==NULL){	
			printf("UNDEFINED SYMBOL. A variavel %s nao foi declarada.\n", pf1->lexeme);
			return (UNDEFINED_SYMBOL_ERROR);
		  }	
                  struct node_tac *inst = NULL;


		  t_array* array_info = (t_array*)(lookup(*s_table,$1)->extra);
		  char* tmp0 = createTmp();
		  Node* temp = $3;
		  int i = 0;
		  while(nb_of_children(temp)>1) {
			char* tmp1 = createTmp();
			char* tmp2 = ( i == 0 ) ? NULL : createTmp();
			char lim_lit[200], c_lit[200];
			sprintf(lim_lit, "%d", array_info->lim_inf[i]);
			sprintf(c_lit, "%d", array_info->c[i]);

			printf("%s\n", child(temp,1)->lexeme);
			append_inst_tac(&(tb->code), create_inst_tac(tmp1, child(temp,1)->lexeme, "SUB", lim_lit));
			if( i == 0) {
				append_inst_tac(&(tb->code), create_inst_tac(tmp0, tmp1, "MUL", c_lit));
			} else {
				append_inst_tac(&(tb->code), create_inst_tac(tmp2, tmp1, "MUL", c_lit));
				append_inst_tac(&(tb->code), create_inst_tac(tmp0, tmp0, "ADD", tmp2));
			}
			temp = child(temp,2);
			i++;
			if( i > array_info->ndim){
				printf("INDEX ERROR. %s acessada incorretamente.\n", pf1->lexeme);
				return (UNDEFINED_SYMBOL_ERROR);
			}
		  }

		  char lim_lit[200], s_type[200];
		  sprintf(lim_lit, "%d", array_info->lim_inf[i]);
		  sprintf(s_type, "%d", array_info->size_of_type);

		  if( i > 0){
			  char* tmp1 = createTmp();
			  append_inst_tac(&(tb->code), create_inst_tac(tmp1, temp->lexeme, "SUB", lim_lit));
			  append_inst_tac(&(tb->code), create_inst_tac(tmp0, tmp0, "ADD", tmp1));
		  }else{
			  append_inst_tac(&(tb->code), create_inst_tac(tmp0, temp->lexeme, "SUB", lim_lit));
		  }
		  append_inst_tac(&(tb->code), create_inst_tac(tmp0, tmp0, "MUL", s_type));
		  append_inst_tac(&(tb->code), create_inst_tac(tmp0, $1, ")", tmp0));

		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, idf_node, tmp0, (void*)tb, 2, children);

		}
      ;


listaexpr: expr { 
		  
                  $$ = create_node(lineno, op_node, $1->lexeme, $1->attribute, 0, &$1);}
	   | expr ',' listaexpr
		{ 
		  
		  Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, pf3);
		  $$ = create_node(lineno, op_node, "listaexpr", $1->attribute, 2, children);
		  /*printf("listaexpr %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);*/
		}
	   ;



expr: expr '+' expr  {  char* str = calloc(strlen($1->lexeme)+strlen($3->lexeme)+2, sizeof(char*));
			CAT(str,$1->lexeme,$3->lexeme,"+");
			/*PRECISA VERIFICAR OS OPERANDO PARA VER SE SÃO INT OU FLOAT*/

			t_exp* ex = malloc(sizeof(t_exp));
			ex->code = NULL;			

			char* tmp = createTmp();
			append_inst_tac(&(ex->code), create_inst_tac(tmp, $1->lexeme, "ADD", $3->lexeme));
			
			Node** children; 
			Node* pf1 = $1;
 			Node* pf3 = $3; 
			pack_nodes(&children, 0, pf1);
			pack_nodes(&children, 1, pf3);
			$$ = create_node(lineno, op_node, tmp, (void*)ex, 2, children);
			}
    | expr '-' expr  { 	char* str = calloc(strlen($1->lexeme)+strlen($3->lexeme)+2, sizeof(char*)); 
			CAT(str,$1->lexeme,$3->lexeme,"-");

			
			t_exp* ex = malloc(sizeof(t_exp));
			ex->code = NULL;	

			char* tmp = createTmp();
			append_inst_tac(&(ex->code), create_inst_tac(tmp, $1->lexeme, "SUB", $3->lexeme));

			Node** children; 
			Node* pf1 = $1;
 			Node* pf3 = $3; 
			pack_nodes(&children, 0, pf1);
			pack_nodes(&children, 1, pf3);
			$$ = create_node(lineno, op_node, tmp, (void*)ex, 2, children);
			}
    | expr '*' expr  { 	char* str = calloc(strlen($1->lexeme)+strlen($3->lexeme)+2, sizeof(char*)); 
			CAT(str,$1->lexeme,$3->lexeme,"*");

			t_exp* ex = malloc(sizeof(t_exp));
			ex->code = NULL;

			char* tmp = createTmp();
			append_inst_tac(&(ex->code), create_inst_tac(tmp, $1->lexeme, "MUL", $3->lexeme));

			Node** children; 
			Node* pf1 = $1;
 			Node* pf3 = $3; 
			pack_nodes(&children, 0, pf1);
			pack_nodes(&children, 1, pf3);
			$$ = create_node(lineno, op_node, tmp, (void*)ex, 2, children);
			}
    | expr '/' expr  { 	char* str = calloc(strlen($1->lexeme)+strlen($3->lexeme)+2, sizeof(char*)); 
			CAT(str,$1->lexeme,$3->lexeme,"/");

			t_exp* ex = malloc(sizeof(t_exp));
			ex->code = NULL;

			char* tmp = createTmp();
			append_inst_tac(&(ex->code), create_inst_tac(tmp, $1->lexeme, "DIV", $3->lexeme));

			Node** children; 
			Node* pf1 = $1;
 			Node* pf3 = $3; 
			pack_nodes(&children, 0, pf1);
			pack_nodes(&children, 1, pf3);
			$$ = create_node(lineno, op_node, tmp, (void*)ex, 2, children);
			}
    | '(' expr ')'   { 	$$ = $2; }
    | INT_LIT 	     { 	
			t_exp* ex = malloc(sizeof(t_exp));
			ex->code = NULL;	
			$$ = create_leaf(lineno, int_node, $1, (void*)ex);
		     }		      
    | F_LIT    	     { 	
			t_exp* ex = malloc(sizeof(t_exp));
			ex->code = NULL;
			$$ = create_leaf(lineno, real_node, $1, NULL);
		     }		      
    | rvalue         {  $$ = $1;}
    | chamaproc      {	$$ = $1;}
    ;



chamaproc: IDF '(' listaexpr ')'
		{Node** children; 
		 Node* pf1 = create_leaf(lineno, idf_node, $1, NULL);
 		 Node* pf3 = $3; 
		 pack_nodes(&children, 0, pf1);
		 pack_nodes(&children, 1, pf3);
		 $$ = create_node(lineno, proc_node, "chamaproc", NULL, 2, children); 
		 /*printf("chamaproc %s, %s \n", $1, $3->lexeme);*/}
         ;

enunciado: expr   { $$ = $1; /*printf("%s \n",$1->lexeme);*/}
         | IF '(' expbool ')' THEN acoes fiminstcontrole
		{
		 t_exp* ex = malloc(sizeof(t_exp));
		 ex->code = NULL;
		
		 Node** children; 
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

		 t_boolexp* b =	(t_boolexp*)$3->attribute;
		 t_exp* f = (t_exp*)$6->attribute;

		 char* lb_true = createLbl();
		 char* lb_false = createLbl();
		 char* lb_final = createLbl();

		 verify_bool_exp($3, lb_true, lb_false);
					
		 cat_tac(&(ex->code), &(b->code));
		 /* label do then */
		 append_inst_tac(&(ex->code), create_inst_tac(lb_true, "", "LABEL", ""));
		 /* codigo do then */
		 cat_tac(&(ex->code), &(f->code)); 
		 /* goto Next */
		 append_inst_tac(&(ex->code), create_inst_tac("GOTO", "", "GOTO", lb_final));
                 /* label do else */										
		 append_inst_tac(&(ex->code), create_inst_tac(lb_false, "", "LABEL", ""));
		 /* código do else */
		
		 /* label Next */
		append_inst_tac(&(ex->code), create_inst_tac(lb_final, "", "LABEL", ""));	

		$$ = create_node(lineno, cond_node, "enunciado", (void*)ex, 5, children); 
		 /*printf("enunciado %s, %s \n", $1, $5);*/}
         | WHILE '(' expbool ')' '{' acoes '}'
		{Node** children; 
		 Node* pf1 = create_leaf(lineno, while_node, $1, NULL);
 		 Node* pf2 = $3;
		 Node* pf3 = $6; 
		 pack_nodes(&children, 0, pf1);
		 pack_nodes(&children, 1, pf2);
		 pack_nodes(&children, 2, pf3);
		 cat_tac(&l_inst, &((t_boolexp*)($3->attribute))->code);
		 $$ = create_node(lineno, cond_node, "enunciado", NULL, 3, children); 
		 /*printf("enunciado %s, %s \n", $3->lexeme, $6->lexeme);*/}
	 | PRINTF '(' expr ')'
		{Node** children;
		 Node* pf1 = create_leaf(lineno, print_node, $1, NULL);
		 Node* pf2 = $3;
		 
		 t_exp* ex = malloc(sizeof(t_exp));
		 ex->code =NULL;

		 //struct node_tac *inst = NULL;
		 append_inst_tac(&(ex->code), create_inst_tac("PRINT", $3->lexeme, "_", ""));
		 //cat_tac(&l_inst, &inst);
		 pack_nodes(&children, 0, pf1);
		 pack_nodes(&children, 1, pf2);
		 $$ = create_node(lineno, print_node, "enunciado", (void*)ex, 2, children);
		}
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
		 /*printf("fiminstcontrole %s, %s \n", $1, $3);*/}
               ;

expbool: TRUE { 	
			t_boolexp* tb = malloc(sizeof(t_boolexp));	
			$$ = create_leaf(lineno, true_node, "true", tb);}
       | FALSE { 	
			t_boolexp* tb = malloc(sizeof(t_boolexp));			
		       	$$ = create_leaf(lineno, false_node, "false", tb);}

       | '(' expbool ')' { //$$ = $2;
		     	 t_boolexp* tb = malloc(sizeof(t_boolexp));			
			 Node** children;
			 pack_nodes(&children,0,create_leaf(lineno, parent_node, "(", NULL));
			 pack_nodes(&children,1,$2);
			 pack_nodes(&children,2,create_leaf(lineno, parent_node,")",NULL));
			 $$ = create_node(lineno,cond_node,"()",tb,3,children);

			}
       | expbool AND expbool
		{ 
		  t_boolexp* tb = malloc(sizeof(t_boolexp));
		  Node** children;
		  Node* node_and = create_leaf(lineno, and_node, "&", NULL);
		  pack_nodes(&children, 0, $1);
		  pack_nodes(&children, 1, node_and);
		  pack_nodes(&children, 2, $3);

		  $$ = create_node(lineno, cond_node, "expbool", tb, 3, children);

		}
       | expbool OR expbool
		{ 
		  t_boolexp* tb = malloc(sizeof(t_boolexp));
		  Node** children;
		  Node* node_or = create_leaf(lineno, or_node, "|", NULL);	  
		  pack_nodes(&children, 0, $1);
		  pack_nodes(&children, 1, node_or);
		  pack_nodes(&children, 2, $3);
	
		  $$ = create_node(lineno, cond_node, "expbool", tb, 3, children);
		}
       | NOT expbool
		{ 
 		  t_boolexp* tb = malloc(sizeof(t_boolexp));
		  Node** children; 
		  Node* pf1 = create_leaf(lineno, not_node, "not", NULL);
		  pack_nodes(&children, 0, pf1);
		  pack_nodes(&children, 1, $2);
		  
		  $$ = create_node(lineno, cond_node, "expbool", tb, 2, children);
		  /*printf("expbool %s , %s, %d \n", $1, $2->lexeme, lineno);*/
		}
       | expr '>' expr
		{ t_boolexp *at = malloc(sizeof(t_boolexp));
		  Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children,0,$1);
		  pack_nodes(&children,1,create_leaf(lineno, sup_node,">",NULL));
		  pack_nodes(&children,2,$3);
		  $$ = create_node(lineno, cond_node, ">", at, 3, children);
		  /*printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);*/
		}
       | expr '<' expr
		{ t_boolexp *at = malloc(sizeof(t_boolexp));
		  Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children,0,$1);
		  pack_nodes(&children,1,create_leaf(lineno, inf_node,"<",NULL));
		  pack_nodes(&children,2,$3);
		  $$ = create_node(lineno, cond_node, "<", at, 3, children);
		  /*printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);*/
		}
       | expr LE expr
		{ t_boolexp *at = malloc(sizeof(t_boolexp));
		  Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children,0,$1);
		  pack_nodes(&children,1,create_leaf(lineno, inf_eq_node,"<=",NULL));
		  pack_nodes(&children,2,$3);
		  $$ = create_node(lineno, cond_node, "<=", at, 3, children);
		  /*printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);*/
		}
       | expr GE expr
		{ t_boolexp *at = malloc(sizeof(t_boolexp));
		  Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children,0,$1);
		  pack_nodes(&children,1,create_leaf(lineno, sup_eq_node,">=",NULL));
		  pack_nodes(&children,2,$3);
		  $$ = create_node(lineno, cond_node, ">=", at, 3, children);
		  /*printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);*/
		}
       | expr EQ expr
		{ t_boolexp *at = malloc(sizeof(t_boolexp));
		  Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children,0,$1);
		  pack_nodes(&children,1,create_leaf(lineno, eq_node,"==",NULL));
		  pack_nodes(&children,2,$3);
		  $$ = create_node(lineno, cond_node, "==", at, 3, children);
		  /*printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);*/
		}
       | expr NE expr
		{ t_boolexp *at = malloc(sizeof(t_boolexp));
		  Node** children;
		  Node* pf1 = $1; 
		  Node* pf3 = $3;
		  pack_nodes(&children,0,$1);
		  pack_nodes(&children,1,create_leaf(lineno, neq_node,"!=",NULL));
		  pack_nodes(&children,2,$3);
		  $$ = create_node(lineno, cond_node, "!=", at, 3, children);
		  /*printf("expbool %s , %s, %d \n", $1->lexeme, $3->lexeme, lineno);*/
		}
       ;
%%


t_boolexp* create_expbool(struct node_tac* _code, char* _c, char* _w)
{
	t_boolexp* tb = calloc(1, sizeof(t_boolexp));
	tb->code = _code;
	tb->correct = _c;
	tb->wrong = _w;

	return tb;
}




 /* A partir daqui, insere-se qlqer codigo C necessario.
  */

void op_bool(Node* node, char* _true, char* _false)
{
	t_boolexp* tb = node->attribute;
	char* new_lb = createLbl();

	switch (child(node,1)->type)
	{
		case not_node:{  //not			
			verify_bool_exp(child(node,2),_false,_true);
			t_boolexp* f = child(node,2)->attribute;
			tb->code = f->code;			
			return;}
		case parent_node:{ //( )
			verify_bool_exp(child(node,2),_true,_false);
			t_boolexp* f = child(node,2)->attribute;
			tb->code = f->code;
			return;}
	}

	switch(child(node,2)->type)
	{
		case and_node: {// nnd			
			verify_bool_exp(child(node,1),new_lb,_false);
			verify_bool_exp(child(node,3),_true,_false);					
			tb->code = NULL;
			t_boolexp* filho0 = child(node,1)->attribute;
			t_boolexp* filho2 = child(node,3)->attribute;	
			cat_tac(&tb->code, &filho0->code);					
			/* continua avaliando: true */
			append_inst_tac(&(tb->code), create_inst_tac(new_lb, "", "LABEL", ""));
			cat_tac(&tb->code,&filho2->code);
		        break;}
		case or_node: {  //or					
			verify_bool_exp(child(node,1),_true,new_lb);
			verify_bool_exp(child(node,3),_true,_false);
					
			tb->code = NULL;
			t_boolexp* filho0 = child(node,1)->attribute;
			t_boolexp* filho2 = child(node,3)->attribute;
					
			cat_tac(&tb->code,&filho0->code);				
			/* continua avaliando: false */
			append_inst_tac(&(tb->code), create_inst_tac(new_lb, "", "LABEL", ""));
			cat_tac(&tb->code,&filho2->code);
			break; }
		default: { 
			/*  < , > , <= , >= , == . != */
			/* B -> B1 op B2 */
			printf("--------> %s\n",node->lexeme);
			tb->code = NULL;
			t_exp* filho0 = child(node,1)->attribute;
			t_exp* filho2 = child(node,3)->attribute;
			printf("ahahhah\n");
			/* código do filho0 */
			printf("%p\n", filho0);
			cat_tac(&tb->code,&filho0->code);
                     printf("primeiro cat\n");		
			/* código do filho2 */
			cat_tac(&tb->code,&filho2->code);
			char* op = calloc(200,sizeof(char));
			//strcat(op, "(");
		  	strcat(op, processa_arg(child(node,1)->lexeme,-1));
			strcat(op, " ");
		  	strcat(op, child(node,2)->lexeme);
			strcat(op, " ");
		  	strcat(op, processa_arg(child(node,3)->lexeme,-1));
			//strcat(op, ")");
			
					
			/* código do IF .. THEN .. IF op goto label*/ 
			append_inst_tac(&(tb->code), create_inst_tac("IF",op,"IF",_true));
			/* GOTO _false*/
			append_inst_tac(&(tb->code), create_inst_tac("GOTO", "", "GOTO", _false));
			break;}
	}

	
}

void verify_bool_exp(Node* node, char* _true, char* _false)
{
	t_boolexp* tb = node->attribute;
	switch(node->type)
	{
		case cond_node:
			op_bool(node, _true, _false);
			break;
		case true_node:
			tb->code = NULL;
			append_inst_tac(&(tb->code), create_inst_tac("GOTO", "", "GOTO", _true));
			break;	
		case false_node:
			tb->code = NULL;
			append_inst_tac(&(tb->code), create_inst_tac("GOTO", "", "GOTO", _false));
			break;	
	}	
}


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

/* o mesmo que a anterior, porém verifica a extensão .tac */
int validOutputExtension(char* s){
  int length = strlen(s);
  if (length < 4) return -1;
  if ((s[length-1] == 'c')&&(s[length-2] == 'a')&&
      (s[length-3] == 't')&&(s[length-4] == '.'))
  	return 0;
  else return -1;
}

static int tmpNumber = 0;
char* createTmp(){
	char* ret;
	int size = 5;
	if (tmpNumber > 9) size++;
	if (tmpNumber > 99) size++;
	ret = calloc(size , sizeof(char));
	sprintf(ret, "tmp%i", tmpNumber);
	tmpNumber++;
	return ret;
}

static int lblNumber = 0;
char* createLbl(){
	char* ret;
	int size = 5;
	if (lblNumber > 9) size++;
	if (lblNumber > 99) size++;
	ret = calloc(size , sizeof(char));
	sprintf(ret, "LABEL%i", lblNumber);
	lblNumber++;
	return ret;
}

/* corta um char nas nas dimensoes especificadas */
char* substr(char* fonte, int pos_i, int pos_f)
{	
	int i,j=0;
	char* sub = malloc((pos_f-pos_i+1)*sizeof(char));
	for (i = pos_i; i<= pos_f; i++)
		sub[j++] = fonte[i];	

	return sub;
}


char* processa_arg(char* s, int line){
	if (strlen(s)==0) return "";
	int n=0, size=1;
	char* rg,*sp = "(SP)",*rx = "(Rx)";
	char* end = calloc(50,sizeof(char));

	 

	//printf("----> %s\n",s);
	
	if ((strlen(s) >= 3) && (s[0]=='t'&&s[1]=='m'&&s[2]=='p')){    	
		size = 4;					/* pegar o tamanho do tipo do tmp */
		rg = rx;
		switch(strlen(s))
		{
		case 4: 					/* para tmp0 ate tmp999 */
			n = atoi(substr(s,3,3)); 
			break;
		case 5: 
			n = atoi(substr(s,3,4)); 
			break;
		case 6: 
			n = atoi(substr(s,3,5)); 
			break;
		}
	}
	else if ((strlen(s) >= 5) && (s[0]=='P'&&s[1]=='R'&&s[2]=='I'&&s[3]=='N'&&s[4]=='T'))
	{
		sprintf(end,"%03d: PRINT",line);
		return end;
	}
	else if ((strlen(s) >= 2) && (s[0]=='I'&&s[1]=='F'))
	{	
		sprintf(end,"%03d: IF",line);
		return end;
	}
	else if ((strlen(s) >= 4) && (s[0]=='G'&&s[1]=='O'&&s[2]=='T'&&s[3]=='O'))
	{
		sprintf(end,"%03d: GOTO",line);
		return end;
	}
	else
	{
		
		rg = sp;
		entry_t* a = lookup(*s_table, s);		/* pega o desloc de s */
		if (a!=NULL){
			//printf("ahhhhhhhhhhhhhhhhhhhhhhhhhhhh!!\n");
			//if (a->extra == NULL)	
				n = a->desloc;}
			//else				/* se for array entra aki */
			
		else return s;
	}

	if (line==-1)
		sprintf(end,"%03d%s",n*size,rg);
	else{	
		sprintf(end,"%03d: %03d%s",line,n*size,rg);
	}

	return end;
}

void print_tac_baixo_nivel(struct node_tac* t, symbol_t *s, char* filename){	
	struct node_tac* temp = t;
	struct node_tac* nova = NULL;
	int line=0;
	
	while(temp != NULL){ 	
		/*printf("tac: %s\n", temp->inst->res);*/	
		append_inst_tac(&nova, 
			create_inst_tac(processa_arg(temp->inst->res,line),processa_arg(temp->inst->arg1,-1),	temp->inst->op, processa_arg(temp->inst->arg2,-1)));
		temp = temp->next;	
		line++;	
	}
   	FILE* output = fopen(filename, "w");
	fprintf(output,"%ld\n",desloc);
	fprintf(output,"%d\n",tmpNumber*4);
   	print_tac(output, nova);
	printf("final da funcao\n");
}

 /* funcao recursiva que percorre os nodos e vai colocando as variaveis na
     tabela de simbolos */
void insert_list_of_vars(Node* n, int var_type)
{
	if (nb_of_children(n) == 0){
		/* cria e insere uma nova entrada na tabela */
		entry_t* var = malloc(sizeof(entry_t));	
		var->name = n->lexeme;
		var->type = var_type;	
		var->size = size_of_type(var_type);
		var->desloc = desloc;
		desloc += var->size;
		insert(s_table, var); 	
	}
	else {
		int i;
		for (i=1; i <= nb_of_children(n); i++)
			insert_list_of_vars(child(n,i), var_type);
	}
}

void insert_list_of_arrays(Node* n, int var_type, t_array* a)
{
	if (nb_of_children(n) == 0){
		/*printf( "variavel: %s \n", n->lexeme);*/
		/* cria e insere uma nova entrada na tabela */
		entry_t* var = malloc(sizeof(entry_t));	
		var->name = n->lexeme;
		var->type = var_type;	
		var->size = size_of_type(var_type)*(a->lim_sup[0] - a->lim_inf[0] +1) ;
		var->desloc = desloc;
		a->size_of_type=size_of_type(var_type);
		var->extra = a;
		desloc += var->size;
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
	case real_node:
		return 4;
	case char_node:
		return 1;
	case double_node:
		return 8;
	}
	return 0;
}

#define DEBUG \
	printf("%s:%s:%i \n", __FILE__, __FUNCTION__, __LINE__)

char* progname;
extern FILE* yyin;

int main(int argc, char* argv[]) 
{
   
   /*inicializa deslocamento para declaração de variáveis*/
   desloc = 0;

   /*inicializa tabela de símbolos*/
   s_table = malloc(sizeof(symbol_t));					
   init_table(s_table);

   if (argc != 4) {
     printf("uso: %s -o <output_file> <input_file>. Try again!\n", argv[0]);
     exit(-1);
   }

   if (validExtension(argv[argc-1]) != 0){
     printf("Invalid Extension, the input file must have .pico extension\n");
     exit(-1);
   }
   
   /* parse the arguments
    * put the output filename in filename
    */ 
   char* filename;
   int i;
   for (i = 0; i < argc; i++){
   	if (strcmp(argv[i], "-o") == 0){
	   if (validOutputExtension(argv[i+1]) !=0) {
		printf("Invalid output extension, the output file must have .tac extension\n");
		exit(-1);
	   }
	   strcpy( filename = calloc(strlen(argv[i+1])+1 , sizeof(char)) , argv[i+1]);
	   /*printf("%s \n", filename);*/ 
	}
   }
  
   yyin = fopen(argv[argc-1], "r");
   if (!yyin) {
     printf("Uso: %s -o <output_file> <input_file>. Could not find %s. Try again!\n", 
         argv[0], argv[argc-1]);
     exit(-1);
   }

   progname = argv[0];

   if (!yyparse()) 
      printf("OKAY.\n");
   else 
      printf("ERROR.\n");
	


   /*opens the output archive to write*/
   char* filename_alto_nivel= calloc((strlen(filename)+3), sizeof(char));
   sprintf(filename_alto_nivel, "%san", filename); 
   FILE* output = fopen(filename_alto_nivel, "w"); 
   print_tac_baixo_nivel(l_inst, s_table, filename);
   print_tac(output, l_inst);
   fclose(output);

   print_tree(syntax_tree);
   
   return(0);
}

void yyerror(char* s) {
  fprintf(stderr, "%s: %s", progname, s);
  fprintf(stderr, "line %d\n", lineno);
}
