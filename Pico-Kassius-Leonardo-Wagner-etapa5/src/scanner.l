 /* Secao das declaracoes */

%option noyywrap
  /* Sera copiado no .c final */
%{
    #include <stdlib.h>
    #include <string.h>
   
    /* este include eh importante... */
    #include "tokens.h"
    extern int lineno;
  
%}
 
  /* Definicoes regulares (A COMPLETAR conforme a especificacao) */
digito     [0-9]


%%

 /* Secao das Regras de traducao */
 /* O que consta aqui eh puramente ilustrativo... A COMPLETAR ! 
  * Ver tambem "tokens.h".
  */

int    	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(INT); }
double   { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(DOUBLE);}
real     { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
  	   return(REAL);}
char     { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(CHAR);}
"print"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(PRINTF);}
"*"      { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('*');}
"+"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('+');}
"-"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('-');}
"/"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('/');}
","	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(',');}
";"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(';');}
":"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(':');}
"'"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(QUOTE);}
"\""	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(DQUOTE);} 
"("	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('(');}
")"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(')');}
"["	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('[');}
"]"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(']');}
"{"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('{');}
"}"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);	
     	   return('}');}
"<"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('<');}
">"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('>');}
"="	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return('=');}
"<="     { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(LE);}
">="	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(GE);}
"=="	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);	
   	   return(EQ);}
"!="	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(NE);}
"&"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(AND);}
"|"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(OR);}
"!"	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(NOT);}
if       { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(IF); }
then	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);	
	   return(THEN);}
else	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(ELSE);}
for	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(FOR);}
next	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(NEXT);}
while	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(WHILE);}
repeat	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(REPEAT);}
until	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(UNTIL);}
end	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(END);}
true	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(TRUE);}
false	 { strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
	   return(FALSE);}

[\n]+ { lineno+=1; }
[ \t]+ { }
			

(\-)?{digito}+ {
		strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
		return INT_LIT;
	  }
 
[A-Za-z_][A-Za-z0-9_]*  { 
				strcpy( yylval.cadeia = 
					calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
				return IDF;
			}

(\-)?{digito}+\.{digito}+((e|E)(\-|\+)?{digito}+)? {
						strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
						return F_LIT; 
					      }


  /* Tratamento dos erros lexicais: a regra seguinte pega tudo o que nao
   * fechou com uma Regexp anterior.
   */
. { printf("Erro lexical - caractere nao reconhecido: %c.\n", yytext[0]);
    exit(-1); }
%%
 /* Secao dos  Procedimentos auxiliares  */

 /* Para redefinir a entrada padrao do LEX. 
  * Redefinir a variavel 'yyin' para ler de um arquivo. Por exemplo:
     yyin = fopen("Meu_programa.c", "r");
  * ira mandar ler o programa a ser compilado pelo analisador lexical
  * em 'Meu_programa.c'.
  * O default eh ler da entrada standard (o teclado).
  */

extern FILE *yyin;
