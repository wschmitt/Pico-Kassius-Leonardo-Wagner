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

int    	 { return(INT); }
double   { return(DOUBLE);}
float    { return(FLOAT);}
char     { return(CHAR);}
"*"      { return('*');}
"+"	 { return('+');}
"-"	 { return('-');}
"/"	 { return('/');}
","	 { return(',');}
";"	 { return(';');}
":"	 { return(':');}
"'"	 { return(QUOTE);}
"\""	 { return(DQUOTE);} 
"("	 { return('(');}
")"	 { return(')');}
"["	 { return('[');}
"]"	 { return(']');}
"{"	 { return('{');}
"}"	 { return('}');}
"<"	 { return('<');}
">"	 { return('>');}
"="	 { return('=');}
"<="     { return(LE);}
">="	 { return(GE);}
"=="	 { return(EQ);}
"!="	 { return(NE);}
"&"	 { return(AND);}
"|"	 { return(OR);}
"!"	 { return(NOT);}
if       { return(IF); }
then	 { return(THEN);}
else	 { return(ELSE);}
for	 { return(FOR);}
next	 { return(NEXT);}
while	 { return(WHILE);}
repeat	 { return(REPEAT);}
until	 { return(UNTIL);}
end	 { return(END);}
true	 { return(TRUE);}
false	 { return(FALSE);}

[\n]+ { lineno+=1; }
[ \t]+ { }
			

{digito}+ {
		strcpy( yylval.cadeia = calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
		return INT_LIT;
	  }
 
[A-Za-z_][A-Za-z0-9_]*  { 
				/*printf("%s\n",yytext);*/
				strcpy( yylval.cadeia = 
					calloc(strlen(yytext)+1 , sizeof(char*)) , yytext);
				return IDF;
			}

{digito}+\.{digito}+((e|E)(\-|\+)?{digito}+)? { 
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
