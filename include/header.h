/*****************************************************************************/
/**  Ejemplo de un posible fichero de cabeceras ("header.h") donde situar   **/
/**  las definiciones de constantes, variables y estructuras globales. Los  **/
/**  alumos deber�n adaptarlo al desarrollo de su propio compilador.        **/
/*****************************************************************************/
#ifndef _HEADER_H
#define _HEADER_H

#define TRUE  1
#define FALSE 0
/********************************** Variables externas definidas en el AL ****/
extern FILE *yyin;
extern int   yylineno;
extern int   yydebug;
extern int   yyleng;
extern char *yytext;
/************************** Variables externas definidas en Prog.Principal ****/
extern int verbosidad;               /* Flag para saber si se desea una traza */
extern int numErrores;               /* Contador del numero de errores        */
extern int dvar; 		     /* Desplazamiento relativo en el Segmento de Variables */


#endif  /* _HEADER_H */
/*****************************************************************************/