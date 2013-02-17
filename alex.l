%{
#include <stdio.h>
#include "header.h"
#include "asin.h"
extern int verbosidad;
#define MAX_LENGTH 14
#define Devolver(x) if (verbosidad) ECHO; return x;

void creaNombre();
void creaCentera();
void truncCreal();

%}

%option yylineno

delimitador [" "|\t]+
nueva_linea "\n"
entero [0-9]+
real [0-9]\.[0-9]*
variable [a-z][a-z|0-9|A-Z|_]*|[A-Z][a-z|0-9|A-Z|_]*
comentario "//".*

%%

{nueva_linea}	{if (verbosidad == TRUE) fprintf(stdout,"\n%3d.- ", yylineno);}
{delimitador} 	{if (verbosidad == TRUE) ECHO;}
{comentario} 	{if (verbosidad == TRUE) ECHO;}
"int" 		{Devolver(INT_);}
"if" 		{Devolver(IF_);}
"else" 		{Devolver(ELSE_);}
"read" 		{Devolver(READ_);}
"return" 	{Devolver(RETURN_);}
"print" 	{Devolver(PRINT_);}
"while"		{Devolver(WHILE_);}
"{" 		{Devolver(LLAVABR_);}
"}" 		{Devolver(LLAVCER_);}
"[" 		{Devolver(CORABR_);}
"]" 		{Devolver(CORCER_);}
"(" 		{Devolver(PARABR_);}
")" 		{Devolver(PARCER_);}
";" 		{Devolver(PC_);}
"," 		{Devolver(COMA_);}
"+"			{Devolver(MAS_);}
"++" 		{Devolver(DMAS_);}
"-"			{Devolver(MENOS_);}
"--"		{Devolver(DMENOS_);}
"*"			{Devolver(MULT_);}
"/"			{Devolver(DIV_);}
"<" 		{Devolver(MAYOR_);}
">" 		{Devolver(MENOR_);}
">=" 		{Devolver(MAYORIGUAL_);}
"<=" 		{Devolver(MENORIGUAL_);}
"=" 		{Devolver(ASIG_);}
"!="		{Devolver(NEGACION_);}
"=="		{Devolver(IGUALDOBLE_);}
{real} 		{truncCreal() ;Devolver(CTE_);}
{entero} 	{creaCentera() ;Devolver(CTE_);}
{variable} 	{creaNombre(); Devolver(ID_);}
. 			{printf("Caracter Desconocido");}

%%
/******************************************************************************/
/* Comprueba que el identificador no exceda la talla maxima (14); en ese caso, lo trunca.*/
void creaNombre(){
	char *t;
	if (yyleng > MAX_LENGTH) {
		fprintf(stdout,"Warning at line %d: identificador truncado a longitud %d\n",
				yylineno, MAX_LENGTH);
		yyleng=MAX_LENGTH;
	}
	t = (char *)malloc(yyleng+1);
	strncpy(t, yytext, yyleng);
	t[yyleng] = '\0';
	yylval.ident = t;
}


/* Transforma una subcadena a la constante entera que representa*/
void creaCentera() { yylval.cent = atoi(yytext); }


/* Transforma una subcadena, que representa una constante real, a una constante entera truncandola.*/
void truncCreal(){
	char *t;
	fprintf(stdout,"Warning at line %d: constante real truncada a entera\n", yylineno);
	yyleng = strcspn(yytext,".");
	t = (char *)malloc(yyleng+1);
	strncpy(t, yytext, yyleng);
	t[yyleng] = '\0';
	yylval.cent = atoi(t);
}
/*****************************************************************************/
