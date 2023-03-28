%{ 
    #include <stdio.h>
    #include <stdlib.h> 
    void yyerror(char *); 
    #include "tab_simb.tab.h" 
%} 

%% 

[a-z]       { 	yylval = *yytext - 'a';
		printf("Variavel: %c - indice %d\n",yytext[0], yylval); 
                return VARIABLE; } 
[0-9]+      { 	yylval = atoi(yytext);
		printf("Valor inteiro: %d\n",yylval);
                return INTEGER; } 
[-+()=/*\n] { 	
		printf("Operador: %c\n", yytext[0]);
		return *yytext; } 

[ \t]    	; 

.             	yyerror("invalid character"); 

%%
 
int yywrap(void) { 
    return 1; 
} 
