%{
#include <string.h>
#include <stdio.h>
int yylex(void);
#include "gram.tab.h"

%}
ws [ \t]
%%
ws           { }

"o"          { strcpy(yylval.str,yytext); return O;}
"a"          { strcpy(yylval.str,yytext); return A; }
"gato"       { strcpy(yylval.str,yytext); return GATO; }
"cachorro"   { strcpy(yylval.str,yytext); return CACHORRO;}
"comida"     { strcpy(yylval.str,yytext); return COMIDA;}
"biscoito"   { strcpy(yylval.str,yytext); return BISCOITO;}
"é"          { strcpy(yylval.str,yytext); return EH;}
"come"       { strcpy(yylval.str,yytext); return COME;}
"bonito"     { strcpy(yylval.str,yytext); return BONITO;}
"feio"       { strcpy(yylval.str,yytext); return FEIO;}

%%

int yywrap (void)
{
  return 1;
}