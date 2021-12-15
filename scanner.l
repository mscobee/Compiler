/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "types.h"
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

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{comment2}  	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"true"    { ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
"false"     { ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
"<"		{ ECHO; return(RELOP); }
"="		{ ECHO; return(RELOP); }
"/="	{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
">="	{ ECHO; return(RELOP); }
"<="	{ ECHO; return(RELOP); }
"+"		{ ECHO; return(ADDOP); }
"-"     { ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"/"     { ECHO; return(MULOP); }
"or"    { ECHO; return(OROP);  }
"not"   { ECHO; return(NOTOP); }
"=>"    {ECHO; return(ARROW); }
"**"     {ECHO; return(EXPOP); }
rem    { ECHO; return(REMOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
real        {ECHO; yylval.type = REAL_TYPE; return(REAL);}
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
case    {ECHO; return(CASE); }
else    {ECHO; return(ELSE); }
endcase    {ECHO; return(ENDCASE); }
endif    {ECHO; return(ENDIF); }
if    {ECHO; return(IF); }
others    {ECHO; return(OTHERS); }
then    {ECHO; return(THEN); }
when    {ECHO; return(WHEN); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }
{real_literal}  { ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL);}
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
