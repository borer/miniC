%{
	#include <stdio.h>
	#include "header.h"
	#include "libtds.h"
%}

%error-verbose

%union
{
	/* Tipo para almacenar el lexema de un identificador */
	char *ident;

	/* el valor de una constante numérica entera */
	int cent;

	struct params params;
}

%token PC_ INT_ STRUCT_ COMA_
%token IF_ ELSE_ WHILE_ RETURN_
%token PARABR_ PARCER_ CORABR_ CORCER_ LLAVABR_ LLAVCER_
%token PRINT_ READ_
%token ASIG_  MENOR_ MAYOR_ IGUALDOBLE_ MAYORIGUAL_ MENORIGUAL_ NEGACION_ 
%token MAS_ DMAS_ MENOS_ DMENOS_ DIV_ MULT_

%token <ident> ID_
%token <cent> CTE_

%type <params> listaParametrosFormales parametrosFormales

%%

Programa: {contexto = GLOBAL; cargaContexto(contexto); dvar = 0;} 

		secuenciaDeclaraciones 

		{ 
			if (verTDS) {
				mostrarTDS(contexto);
			}
			
			descargaContexto(contexto); 
		};

//*********************************************************************************************************************************

secuenciaDeclaraciones: declaracion
	| secuenciaDeclaraciones declaracion;
	
//*********************************************************************************************************************************

declaracion: declaracionVariable
	| declaracionFuncion;

//*********************************************************************************************************************************

declaracionVariable: INT_ ID_ PC_  
		{
			char *name = $2; 
			insertaSimbolo(name, VARIABLE, T_ENTERO, dvar, contexto, -1);
			dvar += TALLA_ENTERO;
		}

	| INT_ ID_ CORABR_ CTE_ CORCER_ PC_ 
		{
			int array_info;
			char *name = $2;
			int num_elem = $4;

			if (num_elem <= 0) {
				yyerror("Talla inapropiada del array ");
				num_elem = 0;
			}

			array_info = insertaInfoArray(T_ENTERO,num_elem);
			if (!insertaSimbolo(name, VARIABLE, T_ARRAY, dvar, contexto, array_info)) {
				yyerror ("Identificador array repetido");
			}
			dvar += TALLA_ENTERO * num_elem;
		};

//*********************************************************************************************************************************
	
declaracionFuncion: cabeceraFuncion bloque 
		{
			if (verTDS) {
				mostrarTDS(contexto);
			}

			descargaContexto(contexto);
			contexto = GLOBAL;
			dvar=old_dvar; 
		};

//*********************************************************************************************************************************

cabeceraFuncion: INT_ ID_  
		{
			contexto=LOCAL;
			cargaContexto(contexto);

			/*Make a copy of the global desp in order to restore when we exit the function*/
			/*Also reset the desp counter for the function*/
			old_dvar=dvar;
			dvar=0 ;

			/*Reset the counter for desp of parameters*/
			dparam = TALLA_SEGENLACES;
		}


		PARABR_ parametrosFormales PARCER_


		{
			char *name = $2;
			int  dominio_info = $5.refDominio; /*This is 5 instead of 4 because the {} block counts as 1 :)*/

			/*Why we declare the function on level LOCAL*/
			if (!insertaSimbolo(name, FUNCION, T_ENTERO, -1, contexto, dominio_info)) {
				yyerror ("Identificador de funcion repetido");
			}

		};

//*********************************************************************************************************************************

parametrosFormales: 
		{
			/*The function has no params*/
			$$.refDominio = insertaInfoDominio(-1,T_VACIO);
			$$.num_params = 0;
		}

	| listaParametrosFormales 
		{
			/*Accumulate the sum of the number of params and pass it to the level above*/
			$$.num_params = $1.num_params;
			$$.refDominio = $1.refDominio;

		};

//*********************************************************************************************************************************
	
listaParametrosFormales: INT_ ID_ 
		{

			char *name = $2;

			if (!insertaSimbolo(name, PARAMETRO, T_ENTERO, dparam, contexto, -dparam)) {
				yyerror ("Identificador de parametro repetido");
			}
			dparam += TALLA_ENTERO;

			/*Here we are at the end pf the parameter list*/
			$$.num_params = 1;
			$$.refDominio = insertaInfoDominio(-1,T_ENTERO);

		}

	| INT_ ID_ COMA_ listaParametrosFormales
		{
			char *name = $2;

			if (!insertaSimbolo(name, PARAMETRO, T_ENTERO, dparam, contexto, -dparam)) {
				yyerror ("Identificador de parametro repetido");
			}
			dparam += TALLA_ENTERO;

			$$.num_params += 1 + $4.num_params;
			$$.refDominio = insertaInfoDominio($4.refDominio,T_ENTERO);
		};

//*********************************************************************************************************************************
	
bloque: LLAVABR_ declaracionVariableLocal listaInstrucciones RETURN_ expresion PC_ LLAVCER_;

//*********************************************************************************************************************************

declaracionVariableLocal: | declaracionVariableLocal declaracionVariable;

//*********************************************************************************************************************************

listaInstrucciones: | listaInstrucciones instruccion;

//*********************************************************************************************************************************
	
instruccion: LLAVABR_ listaInstrucciones LLAVCER_
	| instruccionExpresion
	| instruccionEntradaSalida
	| instruccionSeleccion
	| instruccionIteracion;

//*********************************************************************************************************************************

instruccionExpresion: PC_
	| expresion PC_;

//*********************************************************************************************************************************
	
instruccionEntradaSalida: READ_ PARABR_ ID_ PARCER_ PC_
	| PRINT_ PARABR_ expresion PARCER_ PC_;

//*********************************************************************************************************************************

instruccionSeleccion: IF_ PARABR_ expresion PARCER_ instruccion ELSE_ instruccion;

//*********************************************************************************************************************************

instruccionIteracion: WHILE_ PARABR_ expresion PARCER_ instruccion;

//*********************************************************************************************************************************

expresion: expresionRelacional
	| ID_ ASIG_ expresion
	{
		SIMB sim = obtenerSimbolo($1);
		$$.tipo = T_ERROR;

		if (sim.categoria==NULO){
			yyerror("Objeto no declarado");
		} else if (($3.tipo!=T_ENTERO)||(sim.tipo!=T_ENTERO))) {
			yyerror("Error de tipos en la asignacion de la \'expresion\'");
		} else {
			$$.tipo = sim.tipo;
		}
	}

	| ID_ CORABR_ expresion CORCER_ ASIG_ expresion;

//*********************************************************************************************************************************
	
expresionRelacional: expresionAditiva
	| expresionRelacional operadorRelacional expresionAditiva;

//*********************************************************************************************************************************
	
expresionAditiva: expresionMultiplicativa
	| expresionAditiva operadorAditivo expresionMultiplicativa;

//*********************************************************************************************************************************
	
expresionMultiplicativa: expresionUnaria
	| expresionMultiplicativa operadorMultiplicativo expresionUnaria;

//*********************************************************************************************************************************
	
expresionUnaria: expresionSufija
	| operadorUnario expresionUnaria
	| operadorIncremento ID_;

//*********************************************************************************************************************************
	
expresionSufija: ID_ CORABR_ expresion CORCER_
	| ID_ operadorIncremento
	| ID_ PARABR_ parametrosActuales PARCER_
	| PARABR_ expresion PARCER_
	| ID_
	| CTE_;

//*********************************************************************************************************************************

parametrosActuales: | listaParametrosActuales;

//*********************************************************************************************************************************

listaParametrosActuales: expresion
	| expresion COMA_ listaParametrosActuales;

//*********************************************************************************************************************************
	
operadorRelacional: MAYOR_
	| MENOR_
	| MAYORIGUAL_
	| MENORIGUAL_
	| IGUALDOBLE_
	| NEGACION_;

//*********************************************************************************************************************************

operadorAditivo: MAS_
	| MENOS_;

//*********************************************************************************************************************************

operadorMultiplicativo: MULT_
	| DIV_;

//*********************************************************************************************************************************

operadorIncremento: DMAS_
	| DMENOS_;

//*********************************************************************************************************************************
	
operadorUnario: MAS_
	| MENOS_;

%%

yyerror(const char * msg){
        numErrores++; 
	fprintf(stdout, "Error at line %d: %s\n", yylineno, msg);
}

