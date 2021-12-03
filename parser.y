/* Compiler Theory and Design
   Duane J. Jarc */

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"
int yylex();
void yyerror(const char* message);
double *dArray;
Symbols<double> symbols;

double result;
int y = 0;
%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	double value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL CASE WHEN
%token <oper> ADDOP MULOP RELOP REMOP EXPOP 
%token OROP ANDOP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS REAL
%token IF THEN ELSE ENDIF OTHERS ARROW ENDCASE 

%type <value> body statement_with_handle_error statement reductions expression relation term
	factor exponent primary binary unary cases case
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:
	FUNCTION IDENTIFIER parameters RETURNS type ';' |	
	FUNCTION IDENTIFIER RETURNS type ';' |
	error ';' ;

optional_variable:
	optional_variable variable | 
	error ';'| %empty ;

variable:	
	IDENTIFIER ':' type IS statement_with_handle_error {symbols.insert($1,$5);};

parameters:
	parameter optional_parameter;

optional_parameter:
	optional_parameter ',' parameter | %empty ;

parameter:
	IDENTIFIER ':' type {symbols.insert($1,dArray[y]); y++;};

type:
	INTEGER |
	BOOLEAN  | 
	REAL;

body:
	BEGIN_ statement_with_handle_error END ';' {$$ = $2;} ;

statement_with_handle_error:
	statement |
	error {$$ = 0;};


	
statement:
	expression ';'|
	REDUCE operator reductions ENDREDUCE ';' {$$ = $3;} |
	IF expression THEN statement_with_handle_error ELSE statement_with_handle_error ENDIF ';' {$$=evaluateIf($2,$4,$6);}|
	CASE expression IS cases OTHERS ARROW statement_with_handle_error ENDCASE ';'
	{$$ = $<value>4 == $1 ? $4 : $7;} ;

cases:
	cases case 
	{$$ = $<value>1 == $1 ? $1 : $2;} |
	%empty {$$ = NAN;} ;

	/* removed or nothing below did it break anything? */
case:
	WHEN INT_LITERAL ARROW statement_with_handle_error ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_with_handle_error {$$=evaluateReduction($<oper>0,$1,$2);} | 
	%empty {$$=$<oper>0 == ADD ? 0:1;};

expression:
	expression OROP binary {$$=evaluateOr($1,$3);} |
	binary;

relation:
	relation RELOP term {$$ = evaluateRelational($1,$2,$3);} | term;

binary:
	binary ANDOP relation {$$ = evaluateAnd($1,$3);} |
	relation ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);}|
	factor REMOP exponent {$$ = evaluateArithmetic($1, $2, $3);}|
	exponent ;

exponent:
	unary | 
	unary EXPOP exponent ;

unary:
	NOTOP unary {$$ = evaluateNot($2);}| 
	primary;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | REAL_LITERAL | BOOL_LITERAL | 
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	dArray = new double[argc-1];
	for(int i = 1; i < argc; i++) {
		dArray[i-1] = atof(argv[i]);
	}
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	delete[] dArray;
	return 0;
} 
