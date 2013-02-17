/*****************************************************************************/
/**  Ejemplo de un posible fichero de cabeceras ("header.h") donde situar   **/
/**  las definiciones de constantes, variables y estructuras globales. Los  **/
/**  alumos deberán adaptarlo al desarrollo de su propio compilador.        **/
/*****************************************************************************/
#ifndef _HEADER_H
#define _HEADER_H

#define TRUE  1
#define FALSE 0
/****************************************************** Constantes contexto **/
#define GLOBAL 0
#define LOCAL  1
/****************************************************** Tallas tipos *********/
#define TALLA_ENTERO 1
#define TALLA_LOGICO 1
#define TALLA_SEGENLACES 2        /* Talla del segmento de Enlaces de Control*/
/********************************** Variables externas definidas en el AL ****/
extern FILE *yyin;
extern int   yylineno;
extern int   yydebug;
extern int   yyleng;
extern char *yytext;
/********************** Variables externas definidas en Programa Principal ***/
extern int verbosidad; /* Flag para saber si se desea una traza */
extern int numErrores; /* Contador del numero de errores */
extern int verTDS;     /* Flag para saber si mostrar la TDS */
/*************************** Variables externas definidas en las librer las ***/
extern int dvar;       /* Desplazamiento relativo en el Segmento de Variables */
int old_dvar;
/**************** Variables globales propias de uso en todo el compilador ****/
int contexto;          /* Contexto (global o local) de las variables */

#endif  /* _HEADER_H */
/*****************************************************************************/
