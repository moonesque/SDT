%option noyywrap
%{
#include <cstdio>
#include <iostream>
#define YY_DECL extern "C" int yylex()
using namespace std;
class  matrix { 
   int **p, m, n; 
public: 
   matrix(int row, int col);
   ~matrix();
   void getChar(char* str); 
   void display(); 
};
#include "matrix.tab.h"
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;
%}

%option yylineno

X [+-]?([0-9]+)(","|";")
Y [+-]?([0-9]+)

%%


[ \t]	;// ignore all whitespace

[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return T_FLOAT;}

[0-9]+		{yylval.ival = atoi(yytext); return T_INT;}
"["(" "|{X})*{Y}"]"	{yylval.strval =strdup(yytext); return T_STRVAL;}

\n		{return T_NEWLINE;}

"+"		{return T_PLUS;}

"-"		{return T_MINUS;}

"*"		{return T_MULTIPLY;}

"/"		{return T_DIVIDE;}

"("		{return T_OPEN;}

")"		{return T_CLOSE;}
"^"		{return T_POW;}

"exit"		{return T_QUIT;}

"quit"		{return T_QUIT;}

.               {fprintf(stderr,"unrecognized token at line %d \n", yylloc.first_line);}

%%
