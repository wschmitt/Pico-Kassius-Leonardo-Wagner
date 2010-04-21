#ifndef lint
static const char yysccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93";
#endif

#include <stdlib.h>
#include <string.h>

#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define YYPATCH 20090221

#define YYEMPTY        (-1)
#define yyclearin      (yychar = YYEMPTY)
#define yyerrok        (yyerrflag = 0)
#define YYRECOVERING() (yyerrflag != 0)

/* compatibility with bison */
#ifdef YYPARSE_PARAM
/* compatibility with FreeBSD */
#ifdef YYPARSE_PARAM_TYPE
#define YYPARSE_DECL() yyparse(YYPARSE_PARAM_TYPE YYPARSE_PARAM)
#else
#define YYPARSE_DECL() yyparse(void *YYPARSE_PARAM)
#endif
#else
#define YYPARSE_DECL() yyparse(void)
#endif /* YYPARSE_PARAM */

extern int YYPARSE_DECL();

static int yygrowstack(void);
#define YYPREFIX "yy"
#line 2 "pico.y"
  /* Aqui, pode-se inserir qualquer codigo C necessario ah compilacao
   * final do parser. Sera copiado tal como esta no inicio do y.tab.c
   * gerado por Yacc.
   */
  #include <stdio.h>
  #include <stdlib.h>
  
  /* macro pra concatenar as partes em str*/
  #define CAT(str,B,C,D) strcat(strcat(strcpy(str, B), C), D)

#line 14 "pico.y"
typedef union {
  char* cadeia;
} YYSTYPE;
#line 49 "y.tab.c"
#define IDF 257
#define INT 258
#define DOUBLE 259
#define FLOAT 260
#define CHAR 261
#define QUOTE 262
#define DQUOTE 263
#define LE 264
#define GE 265
#define EQ 266
#define NE 267
#define AND 268
#define OR 269
#define NOT 270
#define IF 271
#define THEN 272
#define ELSE 273
#define WHILE 274
#define INT_LIT 275
#define F_LIT 276
#define END 277
#define TRUE 278
#define FALSE 279
#define FOR 280
#define NEXT 281
#define UNTIL 282
#define REPEAT 283
#define YYERRCODE 256
static const short yylhs[] = {                           -1,
    0,    0,    2,    2,    4,    5,    5,    6,    6,    7,
    7,    7,    7,    8,    8,    8,    8,    9,    9,    3,
    3,   10,   10,   11,   11,   13,   13,    1,    1,    1,
    1,    1,    1,    1,    1,    1,   14,   12,   12,   12,
   16,   16,   15,   15,   15,   15,   15,   15,   15,   15,
   15,   15,   15,   15,
};
static const short yylen[] = {                            2,
    2,    1,    2,    3,    3,    1,    3,    1,    1,    1,
    1,    1,    1,    4,    4,    4,    4,    3,    5,    2,
    3,    3,    1,    1,    4,    1,    3,    3,    3,    3,
    3,    3,    1,    1,    1,    1,    4,    1,    7,    7,
    1,    3,    1,    1,    3,    3,    3,    2,    3,    3,
    3,    3,    3,    3,
};
static const short yydefred[] = {                         0,
    0,    0,    0,   33,   34,    0,    0,    0,    0,    2,
    0,    0,    0,    0,   23,   36,    0,    0,    0,    0,
    0,    0,    0,   35,    0,    0,    0,    0,    1,    0,
    3,    0,    0,    0,    0,    7,    0,    0,    0,    0,
   43,   44,    0,    0,    0,    0,   32,    0,    0,   30,
   31,    4,    0,    0,    0,    0,    5,    8,    9,   21,
    0,    0,   25,   37,   48,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   27,   45,    0,    0,    0,    0,    0,    0,   46,
   47,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   14,   15,   16,   17,    0,   41,   39,   40,    0,
    0,    0,   42,   19,
};
static const short yydgoto[] = {                          7,
    8,    9,   10,   11,   12,   57,   58,   59,   95,   13,
   24,   15,   38,   16,   45,  108,
};
static const short yysindex[] = {                       -34,
  -29,  -38,  -33,    0,    0,  -31,    0,  117,  -34,    0,
  -49,  -24,  -19,  -30,    0,    0, -201,  -31,  -31,  -40,
  -40,  -27,  -23,    0,  -31,  -31,  -31,  -31,    0,   11,
    0,  -93,  -28,  -31,   27,    0,  103,  -17,   42,  -40,
    0,    0,  -40,   39,  -37,    7,    0,  -39,  -39,    0,
    0,    0,  -11,   -1,    2,    9,    0,    0,    0,    0,
  117,  -31,    0,    0,    0,   32,   12,  -31,  -31,  -31,
  -31,  -31,  -31,  -40,  -40, -177,  -21, -179, -179, -179,
 -179,    0,    0,  117,  117,  117,  117,  117,  117,    0,
    0,  -28,  -28,   47,   13,   17,   19,   21, -256,  -18,
 -162,    0,    0,    0,    0,  -28,    0,    0,    0,   79,
 -159, -179,    0,    0,
};
static const short yyrindex[] = {                         0,
   97,    0,    0,    0,    0,    0,    0,   65,    0,    0,
    0,    0,    0,   74,    0,    0,    0,    0,    0,    0,
    0,  -15,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    1,    0,   67,    0,  -25,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   -8,   -2,    0,
    0,    0,   72,   73,   82,   92,    0,    0,    0,    0,
   94,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   14,   18,   20,   22,   24,   26,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   45,
    0,    0,    0,    0,
};
static const short yygindex[] = {                         0,
  109,    0,   16,  145,  140,    0,    0,    0,    8,    0,
    5,    0,    4,    0,   29,    0,
};
#define YYTABLESIZE 306
static const short yytable[] = {                         43,
   20,   20,   27,   76,   14,    6,   21,   28,    6,   31,
   19,    6,   19,   14,   17,   26,  106,   47,   27,   25,
  107,   26,   39,   28,   29,   24,   24,   24,   24,   24,
   34,   24,   28,   32,   28,   28,   28,   14,   29,   33,
   29,   29,   29,   24,   24,   24,   24,   77,   60,   46,
   28,   28,   83,   28,   51,   35,   29,   29,   52,   29,
   53,   18,   54,   18,   49,   82,   50,   26,   65,   52,
   17,   67,   47,   27,   25,   63,   26,   24,   28,   78,
   27,   25,   64,   26,   28,   28,   96,   97,   98,   79,
   29,   73,   80,   72,   92,   94,   14,   14,   73,   81,
   72,   93,   90,   91,  101,  102,  109,   99,  100,  103,
   14,  104,  110,  105,   23,   35,   35,  113,   35,  114,
   35,  111,  112,   38,    6,   20,   37,   37,   44,   44,
   10,   11,   35,   48,   49,   50,   51,   18,   24,   24,
   12,   24,   61,   24,   27,   25,   62,   26,   44,   28,
   13,   66,   22,   30,    6,   24,   36,   24,   27,   25,
    0,   26,    0,   28,   53,   54,   55,   56,    0,    0,
   37,    0,    0,    0,    0,    0,   84,   85,   86,   87,
   88,   89,   44,   44,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   22,    0,    0,    0,
    0,    0,    1,    0,    0,   22,    0,    0,   22,   40,
   74,   75,    0,    0,    4,    5,    2,   41,   42,    3,
    4,    5,    2,    4,    5,    3,    4,    5,   24,   24,
   24,   24,   24,   24,    0,   28,   28,   28,   28,   28,
   28,   29,   29,   29,   29,   29,   29,    0,    0,    0,
    0,    0,    0,   20,   74,   75,    0,   20,    0,   74,
   75,   51,   51,    0,    0,   52,   52,   53,   53,   54,
   54,   49,   49,   50,   50,   68,   69,   70,   71,    0,
    0,    0,   68,   69,   70,   71,
};
static const short yycheck[] = {                         40,
    0,   40,   42,   41,    0,   40,   40,   47,   40,   59,
   40,   40,   40,    9,   44,   41,  273,   41,   42,   43,
  277,   45,   19,   47,    9,   41,   42,   43,   44,   45,
   61,   47,   41,   58,   43,   44,   45,   33,   41,   59,
   43,   44,   45,   59,   60,   61,   62,   41,   33,   21,
   59,   60,   41,   62,   41,  257,   59,   60,   41,   62,
   41,   91,   41,   91,   41,   62,   41,   93,   40,   59,
   44,   43,   41,   42,   43,   93,   45,   93,   47,   91,
   42,   43,   41,   45,   93,   47,   79,   80,   81,   91,
   93,   60,   91,   62,  272,  275,   92,   93,   60,   91,
   62,  123,   74,   75,   58,   93,  125,   92,   93,   93,
  106,   93,  275,   93,    6,   42,   43,  277,   45,  112,
   47,  106,   44,   59,   58,  125,   18,   19,   20,   21,
   59,   59,   59,   25,   26,   27,   28,   93,   42,   43,
   59,   45,   34,   47,   42,   43,   44,   45,   40,   47,
   59,   43,   59,    9,   58,   59,   17,   61,   42,   43,
   -1,   45,   -1,   47,  258,  259,  260,  261,   -1,   -1,
   62,   -1,   -1,   -1,   -1,   -1,   68,   69,   70,   71,
   72,   73,   74,   75,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  257,   -1,   -1,   -1,
   -1,   -1,  257,   -1,   -1,  257,   -1,   -1,  257,  270,
  268,  269,   -1,   -1,  275,  276,  271,  278,  279,  274,
  275,  276,  271,  275,  276,  274,  275,  276,  264,  265,
  266,  267,  268,  269,   -1,  264,  265,  266,  267,  268,
  269,  264,  265,  266,  267,  268,  269,   -1,   -1,   -1,
   -1,   -1,   -1,  273,  268,  269,   -1,  277,   -1,  268,
  269,  268,  269,   -1,   -1,  268,  269,  268,  269,  268,
  269,  268,  269,  268,  269,  264,  265,  266,  267,   -1,
   -1,   -1,  264,  265,  266,  267,
};
#define YYFINAL 7
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 283
#if YYDEBUG
static const char *yyname[] = {

"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,"'('","')'","'*'","'+'","','","'-'",0,"'/'",0,0,0,0,0,0,0,0,0,0,
"':'","';'","'<'","'='","'>'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,"'['",0,"']'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
"'{'",0,"'}'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"IDF","INT","DOUBLE","FLOAT","CHAR","QUOTE",
"DQUOTE","LE","GE","EQ","NE","AND","OR","NOT","IF","THEN","ELSE","WHILE",
"INT_LIT","F_LIT","END","TRUE","FALSE","FOR","NEXT","UNTIL","REPEAT",
};
static const char *yyrule[] = {
"$accept : code",
"code : declaracoes acoes",
"code : acoes",
"declaracoes : declaracao ';'",
"declaracoes : declaracoes declaracao ';'",
"declaracao : listadeclaracao ':' tipo",
"listadeclaracao : IDF",
"listadeclaracao : IDF ',' listadeclaracao",
"tipo : tipounico",
"tipo : tipolista",
"tipounico : INT",
"tipounico : DOUBLE",
"tipounico : FLOAT",
"tipounico : CHAR",
"tipolista : INT '[' listadupla ']'",
"tipolista : DOUBLE '[' listadupla ']'",
"tipolista : FLOAT '[' listadupla ']'",
"tipolista : CHAR '[' listadupla ']'",
"listadupla : INT_LIT ':' INT_LIT",
"listadupla : INT_LIT ':' INT_LIT ',' listadupla",
"acoes : comando ';'",
"acoes : comando ';' acoes",
"comando : lvalue '=' expr",
"comando : enunciado",
"lvalue : IDF",
"lvalue : IDF '[' listaexpr ']'",
"listaexpr : expr",
"listaexpr : expr ',' listaexpr",
"expr : expr '+' expr",
"expr : expr '-' expr",
"expr : expr '*' expr",
"expr : expr '/' expr",
"expr : '(' expr ')'",
"expr : INT_LIT",
"expr : F_LIT",
"expr : lvalue",
"expr : chamaproc",
"chamaproc : IDF '(' listaexpr ')'",
"enunciado : expr",
"enunciado : IF '(' expbool ')' THEN acoes fiminstcontrole",
"enunciado : WHILE '(' expbool ')' '{' acoes '}'",
"fiminstcontrole : END",
"fiminstcontrole : ELSE acoes END",
"expbool : TRUE",
"expbool : FALSE",
"expbool : '(' expbool ')'",
"expbool : expbool AND expbool",
"expbool : expbool OR expbool",
"expbool : NOT expbool",
"expbool : expr '>' expr",
"expbool : expr '<' expr",
"expbool : expr LE expr",
"expbool : expr GE expr",
"expbool : expr EQ expr",
"expbool : expr NE expr",

};
#endif
#if YYDEBUG
#include <stdio.h>
#endif

/* define the initial stack-sizes */
#ifdef YYSTACKSIZE
#undef YYMAXDEPTH
#define YYMAXDEPTH  YYSTACKSIZE
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 500
#define YYMAXDEPTH  500
#endif
#endif

#define YYINITSTACKSIZE 500

int      yydebug;
int      yynerrs;
int      yyerrflag;
int      yychar;
short   *yyssp;
YYSTYPE *yyvsp;
YYSTYPE  yyval;
YYSTYPE  yylval;

/* variables for the parser stack */
static short   *yyss;
static short   *yysslim;
static YYSTYPE *yyvs;
static unsigned yystacksize;
#line 152 "pico.y"
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
#line 376 "y.tab.c"
/* allocate initial stack or double stack size, up to YYMAXDEPTH */
static int yygrowstack(void)
{
    int i;
    unsigned newsize;
    short *newss;
    YYSTYPE *newvs;

    if ((newsize = yystacksize) == 0)
        newsize = YYINITSTACKSIZE;
    else if (newsize >= YYMAXDEPTH)
        return -1;
    else if ((newsize *= 2) > YYMAXDEPTH)
        newsize = YYMAXDEPTH;

    i = yyssp - yyss;
    newss = (yyss != 0)
          ? (short *)realloc(yyss, newsize * sizeof(*newss))
          : (short *)malloc(newsize * sizeof(*newss));
    if (newss == 0)
        return -1;

    yyss  = newss;
    yyssp = newss + i;
    newvs = (yyvs != 0)
          ? (YYSTYPE *)realloc(yyvs, newsize * sizeof(*newvs))
          : (YYSTYPE *)malloc(newsize * sizeof(*newvs));
    if (newvs == 0)
        return -1;

    yyvs = newvs;
    yyvsp = newvs + i;
    yystacksize = newsize;
    yysslim = yyss + newsize - 1;
    return 0;
}

#define YYABORT  goto yyabort
#define YYREJECT goto yyabort
#define YYACCEPT goto yyaccept
#define YYERROR  goto yyerrlab

int
YYPARSE_DECL()
{
    int yym, yyn, yystate;
#if YYDEBUG
    const char *yys;

    if ((yys = getenv("YYDEBUG")) != 0)
    {
        yyn = *yys;
        if (yyn >= '0' && yyn <= '9')
            yydebug = yyn - '0';
    }
#endif

    yynerrs = 0;
    yyerrflag = 0;
    yychar = YYEMPTY;
    yystate = 0;

    if (yyss == NULL && yygrowstack()) goto yyoverflow;
    yyssp = yyss;
    yyvsp = yyvs;
    yystate = 0;
    *yyssp = 0;

yyloop:
    if ((yyn = yydefred[yystate]) != 0) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("%sdebug: state %d, reading %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: state %d, shifting to state %d\n",
                    YYPREFIX, yystate, yytable[yyn]);
#endif
        if (yyssp >= yysslim && yygrowstack())
        {
            goto yyoverflow;
        }
        yystate = yytable[yyn];
        *++yyssp = yytable[yyn];
        *++yyvsp = yylval;
        yychar = YYEMPTY;
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;

    yyerror("syntax error");

    goto yyerrlab;

yyerrlab:
    ++yynerrs;

yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yyssp]) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: state %d, error recovery shifting\
 to state %d\n", YYPREFIX, *yyssp, yytable[yyn]);
#endif
                if (yyssp >= yysslim && yygrowstack())
                {
                    goto yyoverflow;
                }
                yystate = yytable[yyn];
                *++yyssp = yytable[yyn];
                *++yyvsp = yylval;
                goto yyloop;
            }
            else
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: error recovery discarding state %d\n",
                            YYPREFIX, *yyssp);
#endif
                if (yyssp <= yyss) goto yyabort;
                --yyssp;
                --yyvsp;
            }
        }
    }
    else
    {
        if (yychar == 0) goto yyabort;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("%sdebug: state %d, error recovery discards token %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
        yychar = YYEMPTY;
        goto yyloop;
    }

yyreduce:
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: state %d, reducing by rule %d (%s)\n",
                YYPREFIX, yystate, yyn, yyrule[yyn]);
#endif
    yym = yylen[yyn];
    if (yym)
        yyval = yyvsp[1-yym];
    else
        memset(&yyval, 0, sizeof yyval);
    switch (yyn)
    {
case 28:
#line 107 "pico.y"
	{  char* str = calloc(strlen(yyvsp[-2].cadeia)+strlen(yyvsp[0].cadeia)+2, sizeof(char*)); 
			CAT(str,yyvsp[-2].cadeia,yyvsp[0].cadeia,"+");
			yyval.cadeia = str; }
break;
case 29:
#line 110 "pico.y"
	{ 	char* str = calloc(strlen(yyvsp[-2].cadeia)+strlen(yyvsp[0].cadeia)+2, sizeof(char*)); 
			CAT(str,yyvsp[-2].cadeia,yyvsp[0].cadeia,"-");
			yyval.cadeia = str; }
break;
case 30:
#line 113 "pico.y"
	{ 	char* str = calloc(strlen(yyvsp[-2].cadeia)+strlen(yyvsp[0].cadeia)+2, sizeof(char*)); 
			CAT(str,yyvsp[-2].cadeia,yyvsp[0].cadeia,"*");
			yyval.cadeia = str; }
break;
case 31:
#line 116 "pico.y"
	{ 	char* str = calloc(strlen(yyvsp[-2].cadeia)+strlen(yyvsp[0].cadeia)+2, sizeof(char*)); 
			CAT(str,yyvsp[-2].cadeia,yyvsp[0].cadeia,"/");
			yyval.cadeia = str; }
break;
case 32:
#line 119 "pico.y"
	{ yyval.cadeia = yyvsp[-1].cadeia; }
break;
case 33:
#line 120 "pico.y"
	{ yyval.cadeia = yyvsp[0].cadeia; }
break;
case 38:
#line 129 "pico.y"
	{ printf("%s \n",yyvsp[0].cadeia);}
break;
#line 597 "y.tab.c"
    }
    yyssp -= yym;
    yystate = *yyssp;
    yyvsp -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: after reduction, shifting from state 0 to\
 state %d\n", YYPREFIX, YYFINAL);
#endif
        yystate = YYFINAL;
        *++yyssp = YYFINAL;
        *++yyvsp = yyval;
        if (yychar < 0)
        {
            if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
            if (yydebug)
            {
                yys = 0;
                if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
                if (!yys) yys = "illegal-symbol";
                printf("%sdebug: state %d, reading %d (%s)\n",
                        YYPREFIX, YYFINAL, yychar, yys);
            }
#endif
        }
        if (yychar == 0) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: after reduction, shifting from state %d \
to state %d\n", YYPREFIX, *yyssp, yystate);
#endif
    if (yyssp >= yysslim && yygrowstack())
    {
        goto yyoverflow;
    }
    *++yyssp = (short) yystate;
    *++yyvsp = yyval;
    goto yyloop;

yyoverflow:
    yyerror("yacc stack overflow");

yyabort:
    return (1);

yyaccept:
    return (0);
}
