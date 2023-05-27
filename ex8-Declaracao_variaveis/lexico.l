%{
	#include <string.h>
	#include <stdio.h>
	#include "sintatico.tab.h"
	#include "symbolTable.h"
	void yyerror(char *); 
%}

ws [ \t]
letter [A-Za-z]
digit [0-9]



%%

"//".*\n  {
	cont_lines++;
}

"var"	{
	printf("Lexic: var found\n");
	strcpy(yylval.c.str, yytext);
	return VAR;
}

"int"	{
	printf("Lexic: int found\n");
	strcpy(yylval.c.str, yytext);
	return INT;
}

"read"	{
	printf("Lexic: read found\n");
	strcpy(yylval.c.str, yytext);
	return READ;
}

"write"	{
	printf("Lexic: write found\n");
	strcpy(yylval.c.str, yytext);
	return WRITE;
}

{digit}+  {
	strcpy(yylval.c.str, yytext);
	return NUM;
}


{letter}({letter}|{digit}|_)*	{
	
	strcpy(yylval.c.str, yytext);
	return ID;
}


[-;:={}+*()<>/%] {
	printf("Lexic: %c found\n", *yytext);
	// strcpy(yylval.str, yytext);
	return *yytext;
}


{ws}           { }

\n\r             { cont_lines++; }


. { yyerror("Invalid character"); }

%%

int yywrap (void)
{
 	return 1;
}
