%{
    #include <stdlib.h>
    void yyerror(char *);
    #include "calc.tab.h"
%}



%%
  
[a-z] {
       strcpy (yylval.attribute.temp,yytext) ;
      return VARIABLE; }

[0-9]+  {
   strcpy (yylval.attribute.temp,yytext);
   return INTEGER;
}

[-+()=/*\n] { return *yytext; }

[ \t]   { }
.      {  yyerror("invalid character"); }  
      
 
%%
int yywrap(void) {
return 1;
}