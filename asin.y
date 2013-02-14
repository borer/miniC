%{
	#include <stdio.h>
	/*extern int yylineno;*/
%}

%error-verbose

%token ID_ PC_ CTE_ INT_ STRUCT_ COMA_
%token IF_ ELSE_ WHILE_ RETURN_
%token PARABR_ PARCER_ CORABR_ CORCER_ LLAVABR_ LLAVCER_
%token PRINT_ READ_
%token ASIG_  MENOR_ MAYOR_ IGUALDOBLE_ MAYORIGUAL_ MENORIGUAL_ NEGACION_ 
%token MAS_ DMAS_ MENOS_ DMENOS_ DIV_ MULT_

%%

Programa: secuenciaDeclaraciones;

secuenciaDeclaraciones: declaracion
	| secuenciaDeclaraciones declaracion;
	
declaracion: declaracionVariable
	| declaracionFuncion;

declaracionVariable: INT_ ID_ PC_
	| INT_ ID_ CORABR_ CTE_ CORCER_ PC_;
	
declaracionFuncion: cabeceraFuncion bloque;

cabeceraFuncion: INT_ ID_ PARABR_ parametrosFormales PARCER_;

parametrosFormales: | listaParametrosFormales;
	
listaParametrosFormales: INT_ ID_ 
	| INT_ ID_ COMA_ listaParametrosFormales;
	
bloque: LLAVABR_ declaracionVariableLocal listaInstrucciones RETURN_ expresion PC_ LLAVCER_;

declaracionVariableLocal: | declaracionVariableLocal declaracionVariable;

listaInstrucciones: | listaInstrucciones instruccion;
	
instruccion: LLAVABR_ listaInstrucciones LLAVCER_
	| instruccionExpresion
	| instruccionEntradaSalida
	| instruccionSeleccion
	| instruccionIteracion;

instruccionExpresion: PC_
	| expresion PC_;
	
instruccionEntradaSalida: READ_ PARABR_ ID_ PARCER_ PC_
	| PRINT_ PARABR_ expresion PARCER_ PC_;

instruccionSeleccion: IF_ PARABR_ expresion PARCER_ instruccion ELSE_ instruccion;

instruccionIteracion: WHILE_ PARABR_ expresion PARCER_ instruccion;

expresion: expresionRelacional
	| ID_ ASIG_ expresion
	| ID_ CORABR_ expresion CORCER_ ASIG_ expresion;
	
expresionRelacional: expresionAditiva
	| expresionRelacional operadorRelacional expresionAditiva;
	
expresionAditiva: expresionMultiplicativa
	| expresionAditiva operadorAditivo expresionMultiplicativa;
	
expresionMultiplicativa: expresionUnaria
	| expresionMultiplicativa operadorMultiplicativo expresionUnaria;
	
expresionUnaria: expresionSufija
	| operadorUnario expresionUnaria
	| operadorIncremento ID_;
	
expresionSufija: ID_ CORABR_ expresion CORCER_
	| ID_ operadorIncremento
	| ID_ PARABR_ parametrosActuales PARCER_
	| PARABR_ expresion PARCER_
	| ID_
	| CTE_;

parametrosActuales: | listaParametrosActuales;

listaParametrosActuales: expresion
	| expresion COMA_ listaParametrosActuales;
	
operadorRelacional: MAYOR_
	| MENOR_
	| MAYORIGUAL_
	| MENORIGUAL_
	| IGUALDOBLE_
	| NEGACION_;

operadorAditivo: MAS_
	| MENOS_;

operadorMultiplicativo: MULT_
	| DIV_;

operadorIncremento: DMAS_
	| DMENOS_;
	
operadorUnario: MAS_
	| MENOS_;

%%
