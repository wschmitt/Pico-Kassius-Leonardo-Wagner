%{
  /* Aqui, pode-se inserir qualquer codigo C necessario ah compilacao
   * final do parser. Sera copiado tal como esta no inicio do y.tab.c
   * gerado por Yacc.
   */
  #include <stdio.h>
  #include <stdlib.h>
  
  /* macro pra concatenar as partes em str*/
  #define CAT(str,B,C,D) strcat(strcat(strcpy(str, B), C), D)

%}

%union {
  char* cadeia;
}

%type< cadeia > expr

%token IDF
%token INT
%token DOUBLE
%token FLOAT
%token CHAR
%token QUOTE
%token DQUOTE
%token LE
%token GE
%token EQ
%token NE
%token AND
%token OR
%token NOT
%token IF
%token THEN
%token ELSE
%token WHILE
%token< cadeia >  INT_LIT
%token F_LIT
%token END
%token TRUE
%token FALSE
%token FOR
%token NEXT
%token UNTIL
%token REPEAT
%start code

%right '='
%left '+' '-'
%left '*' '/'
%left AND OR NOT

 /* A completar com seus tokens - compilar com 'yacc -d' */

%%
code: declaracoes acoes
    | acoes				
    ;

declaracoes: declaracao ';'
           | declaracoes declaracao ';'
           ;

declaracao: listadeclaracao ':' tipo

listadeclaracao: IDF
               | IDF ',' listadeclaracao
               ;

tipo: tipounico 
    | tipolista
    ;

tipounico: INT
         | DOUBLE
         | FLOAT
         | CHAR
         ;

tipolista: INT '[' listadupla ']'
         | DOUBLE '[' listadupla ']'
         | FLOAT '[' listadupla ']'
         | CHAR '[' listadupla ']'
         ;

listadupla: INT_LIT ':' INT_LIT
          | INT_LIT ':' INT_LIT ',' listadupla
          ;

acoes: comando ';'
    | comando ';' acoes
    ;

comando: lvalue '=' expr
       | enunciado
       ;

lvalue: IDF
      | IDF '[' listaexpr ']'
      ;

listaexpr: expr        
	   | expr ',' listaexpr
	   ;

expr: expr '+' expr  {  char* str = calloc(strlen($1)+strlen($3)+2, sizeof(char*)); 
			CAT(str,$1,$3,"+");
			$$ = str; }
    | expr '-' expr  { 	char* str = calloc(strlen($1)+strlen($3)+2, sizeof(char*)); 
			CAT(str,$1,$3,"-");
			$$ = str; }
    | expr '*' expr  { 	char* str = calloc(strlen($1)+strlen($3)+2, sizeof(char*)); 
			CAT(str,$1,$3,"*");
			$$ = str; }
    | expr '/' expr  { 	char* str = calloc(strlen($1)+strlen($3)+2, sizeof(char*)); 
			CAT(str,$1,$3,"/");
			$$ = str; }			
    | '(' expr ')'   { $$ = $2; }
    | INT_LIT 	     { $$ = $1; }
    | F_LIT    	   
    | lvalue
    | chamaproc
    ;

chamaproc: IDF '(' listaexpr ')'
         ;

enunciado: expr   { printf("%s \n",$1);}
         | IF '(' expbool ')' THEN acoes fiminstcontrole
         | WHILE '(' expbool ')' '{' acoes '}'
         ;

fiminstcontrole: END
               | ELSE acoes END
               ;

expbool: TRUE 
       | FALSE
       | '(' expbool ')'
       | expbool AND expbool
       | expbool OR expbool
       | NOT expbool
       | expr '>' expr
       | expr '<' expr
       | expr LE expr
       | expr GE expr
       | expr EQ expr
       | expr NE expr
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

char* progname;
int lineno;
extern FILE* yyin;

int main(int argc, char* argv[]) 
{
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
