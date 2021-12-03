/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"
%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
comment2    \/\/.*\n
line		[\n]
id		[A-Za-z]+([A-Za-z0-9]*_[A-Za-z0-9])*[A-Za-z0-9]*
digit		[0-9]
int		{digit}+
real_literal [0-9]+\.[0-9]*[eE]?[+-]?[0-9]*
punc		[\(\),:;]
%%

{ws}		      { ECHO; }
{comment}	   { ECHO; nextLine();}
{comment2}  	{ ECHO; nextLine();}
{line}		   { ECHO; nextLine();}
"<"		      { ECHO; yylval.oper = LESS; return(RELOP); }
"="     	      { ECHO; yylval.oper = EQUAL; return(RELOP); }
"/="     	   { ECHO; yylval.oper = NOT_EQUAL; return(RELOP); }
">"		      { ECHO; yylval.oper = GREAT; return(RELOP); }
">="    	      { ECHO; yylval.oper = GREAT_EQUAL; return(RELOP);}
"<="     	   { ECHO; yylval.oper = LESS_EQUAL; return(RELOP);}
"+"		      { ECHO; yylval.oper = ADD; return(ADDOP); }
"-"      	   { ECHO; yylval.oper = SUB; return(ADDOP);}
"*"		      { ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"      	   { ECHO; yylval.oper = DIVIDE; return(MULOP);}
"or"     	   { ECHO; yylval.oper = OR; return(OROP);}
"not"   	      { ECHO; yylval.oper = NOT; return(NOTOP); }
"=>"    	      { ECHO; yylval.oper = ARROW_; return(ARROW); }
"rem"     	   { ECHO; yylval.oper = REM; return(REMOP); }
"**"     	   { ECHO; yylval.oper = EXP; return(EXPOP); }
true		   { ECHO; yylval.value = 1; return(BOOL_LITERAL);}
false		   { ECHO; yylval.value = 0; return(BOOL_LITERAL);}
begin		      { ECHO; return(BEGIN_); }
boolean		   { ECHO; return(BOOLEAN); }
end		      { ECHO; return(END); }
endreduce	   { ECHO; return(ENDREDUCE); }
function	      { ECHO; return(FUNCTION); }
integer		   { ECHO; return(INTEGER); }
is		         { ECHO; return(IS); }
reduce		   { ECHO; return(REDUCE); }
returns		   { ECHO; return(RETURNS); }
and		      { ECHO; yylval.oper = AND; return(ANDOP); } 
case    	      { ECHO; return(CASE); }
else    	      { ECHO; return(ELSE); }
endcase    	   { ECHO; return(ENDCASE); }
endif    	   { ECHO; return(ENDIF); }
if    		   { ECHO; return(IF); }
others    	   { ECHO; return(OTHERS); }
real    	      { ECHO; return(REAL); }
then        	{ ECHO; return(THEN); }
when         	{ ECHO; return(WHEN); }
{id}	      	{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		      { ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}	   	{ ECHO; return(yytext[0]); }
.		         { ECHO; appendError(LEXICAL, yytext); }
{real_literal}  { ECHO; yylval.value = atof(yytext); return(REAL_LITERAL);}
%%
