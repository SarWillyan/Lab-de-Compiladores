%{
	#include <string.h>
	#include <stdio.h>
	#include "sintatico.tab.h"
	void yyerror(char *); 
	int count_lines=0;
%}

ws [ \t]
letter [A-Za-z]
digit [0-9]
quotes ['\"']
text_str [^'\"']


%%

"//".*\n  {
	count_lines++;
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
	// printf("Lexic: %c found\n", *yytext);
	// strcpy(yylval.str, yytext);
	return *yytext;
}


{ws}           { }

\n             { count_lines++; }

. { yyerror("Invalid character"); }

%%

int yywrap (void)
{
 	return 1;
}
