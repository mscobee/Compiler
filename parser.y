/* Compiler Theory and Design
   Duane J. Jarc */

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token ADDOP MULOP RELOP ANDOP EXPOP OROP NOTOP REMOP
%token ARROW THEN WHEN 
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS 
%token REDUCE RETURNS CASE ELSE ENDCASE ENDIF IF OTHERS REAL

%type <type> type statement statement_with_handle_error reductions expression relation term
	factor primary binary exponent unary

%%

function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' | 
	FUNCTION IDENTIFIER RETURNS type ';' |
	error ';' ;

optional_variable:
	optional_variable variable |
	error ';' |
	;

variable:
	IDENTIFIER ':' type IS statement_with_handle_error 
	{checkAssignment($3, $5, "Variable Initialization");
		symbols.insert($1, $3);};

parameters:
	parameter optional_parameter;

optional_parameter:
	optional_parameter ',' parameter |
	;

parameter:
	IDENTIFIER ':' type;
type:
	INTEGER {$$ = INT_TYPE;}| 
	REAL {$$ = REAL_TYPE;}|
	BOOLEAN {$$ = BOOL_TYPE;};

body:
	BEGIN_ statement_with_handle_error END ';' ;
    
statement_with_handle_error:
	statement |
	error {$$ = MISMATCH;};
	
statement:
	expression ';'|
	REDUCE operator reductions ENDREDUCE ';'|
	IF expression THEN statement_with_handle_error ELSE statement_with_handle_error ENDIF ';'
	{$$ = checkIf($$,$4,$6);} |
	CASE expression IS case_block case_others ENDCASE ';' ;

case_block:
	case_block case_when | 
	case_when  |
	error;

case_when: 
	WHEN INT_LITERAL ARROW statement ;

case_others:
	OTHERS ARROW expression ';' ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_with_handle_error {$$ = checkArithmetic($1, $2);}|
	 {$$ = INT_TYPE;};
	
expression:
	expression OROP binary {$$ = checkLogical($1,$3);} |
	binary;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term;

binary:
	binary ANDOP relation |
	relation ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = checkArithmetic($1, $3);}|
	factor REMOP exponent {$$ = checkRem($1, $3);}|
	exponent ;

exponent:
	unary |
	unary EXPOP exponent {$$ = checkArithmetic($1,$3);};

unary:
	primary |
	NOTOP unary {$$=checkLogical($2, BOOL_TYPE);};

primary:
	'(' expression ')' {$$ = $2;}|
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);};
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
