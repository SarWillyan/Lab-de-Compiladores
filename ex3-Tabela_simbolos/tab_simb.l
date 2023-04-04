%{ 
    void yyerror(const char *); 
    #include "tab_simb.tab.h" 
%} 

%% 

[a-z]+       { 	strcpy(yylval.id, yytext);
		printf("Variavel: %s - indice %d\n",yytext, yylval.num); 
                return VARIABLE; } 
[0-9]+      { 	yylval.num = atoi(yytext);
		printf("Valor inteiro: %d\n",yylval.num);
                return INTEGER; } 
[-+()=*/\n] { 	
		printf("Operador: %c\n", yytext[0]);
		return *yytext; } 

[ \t]    	; 

.             	yyerror("invalid character"); 

%%
 
int yywrap(void) { 
    return 1; 
} 
