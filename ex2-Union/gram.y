/*
Oração irá derivar em: sujeito predicado

Sujeito irá derivar em: artigo substantivo

Artigo irá derivar em: "a" | "o"

Substantivo irá derivar em: "gato" | "cachorro" | "comida" | "biscoito" 

Predicado irá derivar em: verbo complemento

Verbo irá derivar em: "é" | "come"

Complemento irá derivar em: "bonito" | "feio" | substantivo
*/
%{
   #include <string.h>
   #include <stdio.h>
   int yylex(void);
   void yyerror(char *);
%}

%union {
 char str[64];
};

%type <str> art subst sujeito predicado verbo complemento oracao
%token <str> O A GATO CACHORRO COMIDA BISCOITO EH COME BONITO FEIO

%%
oracao : sujeito predicado {
                strcpy($$,$1);
                strcat($$," ");
                strcat($$,$2);
                printf("A oração é: %s\n", $$);
                }

sujeito	: art subst { 
       		strcpy($$, $1);
                strcat($$, " ");
                strcat($$, $2);
                printf("O sujeito é: %s\n", $$);
		}
        ;                
                          
art	: O { 
    		strcpy($$,$1); 
                printf("ART: %s\n",$$);
		}
      	| A {
		strcpy($$,$1); 
                printf("ART: %s\n",$$);
		}
        ;
        
subst	: GATO {
      		strcpy($$,$1);
                printf("SUBST: %s\n",$$);
		}
      	| CACHORRO {
		strcpy($$,$1); 
                printf("SUBST: %s\n",$$);
		}
      	| COMIDA {
		strcpy($$,$1);  
                printf("SUBST: %s\n",$$);
		}
        | BISCOITO {
		strcpy($$,$1);  
                printf("SUBST: %s\n",$$);
		}
      	;

predicado : verbo complemento {
                strcpy($$, $1);
                strcat($$," ");
                strcat($$, $2);
                printf("O predicado é: %s\n", $$);
                }

verbo   : EH {
                strcpy($$, $1);
                printf("VERBO: %s\n", $$);
                }
        | COME {
                strcpy($$, $1);
                printf("VERBO: %s\n", $$);
                }
;

complemento : BONITO {
                strcpy($$, $1);
                printf("COMPLEMENTO: %s\n", $$);
                }
        | FEIO {
                strcpy($$, $1);
                printf("COMPLEMENTO: %s\n", $$);
                }
        /*| subst {
                strcpy($$, $1);
                printf("SUBST: %s\n", $$);
                }*/
;

%%

void yyerror(char *s) {
   printf("%s\n",s);

}

int main (void) {
   yyparse();
   return 0;
}
