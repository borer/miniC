%{
#include <stdio.h>
#include "asin.h"
#include "header.h"
extern int verbosidad;

%}

%option yylineno

delimitador [" "|\t]+
nueva_linea "\n"
entero [0-9]+\.*[0-9]*
variable [a-z][a-z|0-9|A-Z|_]*|[A-Z][a-z|0-9|A-Z|_]*
comentario "//".*

%%

{nueva_linea}	{if (verbosidad == TRUE) fprintf(stdout,"\n%3d.- ", yylineno);}
{delimitador} 	{if (verbosidad == TRUE) ECHO;}
{comentario} 	{if (verbosidad == TRUE) ECHO;}
"int" 		{if (verbosidad == TRUE) ECHO; return INT_;}
"if" 		{if (verbosidad == TRUE) ECHO; return IF_;}
"else" 		{if (verbosidad == TRUE) ECHO; return ELSE_;}
"read" 		{if (verbosidad == TRUE) ECHO; return READ_;}
"return" 	{if (verbosidad == TRUE) ECHO; return RETURN_;}
"print" 	{if (verbosidad == TRUE) ECHO; return PRINT_;}
"while"		{if (verbosidad == TRUE) ECHO; return WHILE_;}
"{" 		{if (verbosidad == TRUE) ECHO; return LLAVABR_;}
"}" 		{if (verbosidad == TRUE) ECHO; return LLAVCER_;}
"[" 		{if (verbosidad == TRUE) ECHO; return CORABR_;}
"]" 		{if (verbosidad == TRUE) ECHO; return CORCER_;}
"(" 		{if (verbosidad == TRUE) ECHO; return PARABR_;}
")" 		{if (verbosidad == TRUE) ECHO; return PARCER_;}
";" 		{if (verbosidad == TRUE) ECHO; return PC_;}
"," 		{if (verbosidad == TRUE) ECHO; return COMA_;}
"+"		{if (verbosidad == TRUE) ECHO; return MAS_;}
"++" 		{if (verbosidad == TRUE) ECHO; return DMAS_;}
"-"		{if (verbosidad == TRUE) ECHO; return MENOS_;}
"--"		{if (verbosidad == TRUE) ECHO; return DMENOS_;}
"*"		{if (verbosidad == TRUE) ECHO; return MULT_;}
"/"		{if (verbosidad == TRUE) ECHO; return DIV_;}
"<" 		{if (verbosidad == TRUE) ECHO; return MAYOR_;}
">" 		{if (verbosidad == TRUE) ECHO; return MENOR_;}
">=" 		{if (verbosidad == TRUE) ECHO; return MAYORIGUAL_;}
"<=" 		{if (verbosidad == TRUE) ECHO; return MENORIGUAL_;}
"=" 		{if (verbosidad == TRUE) ECHO; return ASIG_;}
"!="		{if (verbosidad == TRUE) ECHO; return NEGACION_;}
"=="		{if (verbosidad == TRUE) ECHO; return IGUALDOBLE_;}
{entero} 	{if (verbosidad == TRUE) ECHO; return CTE_;}
{variable} 	{if (verbosidad == TRUE) ECHO; return ID_;}
. 		{printf("Caracter Desconocido");}


%%


