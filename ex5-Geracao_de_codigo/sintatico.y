%{
    #include <string.h>
    #include <stdio.h>
   #include "codeGeneration.h"

    void yyerror(char*);
    int yylex();
    extern int count_lines;
%}

%union {
	struct code_t
	{
		char str[2044]; // string para o codigo asm
		int op; // opcoes (por exemplo nos jumps)
	} c;
}

%type <c> programa expressao_numerica termo fator
%token <c> ID NUM 
%left '+' '-'
%left '*' '/'

%%

programa: expressao_numerica  {
                            printf("%s\n",$1.str);
                        }
;

expressao_numerica: termo  {

		strcpy($$.str, $1.str);
	}

	| expressao_numerica '+' expressao_numerica  {

		makeCodeAdd($$.str, $3.str);
	}

	| expressao_numerica '-' expressao_numerica  {
		
		makeCodeSub($$.str, $3.str);
	}

	| termo '*' fator  {
		
		// printf("{%s}\n", $$.str);
		makeCodeMul($1.str, $3.str);
		strcpy($$.str, $1.str);

	}

	| termo '/' fator  {

		makeCodeDiv($$.str, $3.str);
	}

	| termo '%' fator  {

		makeCodeMod($$.str, $3.str);
	}
;



termo: NUM  {

		makeCodeLoad($$.str, $1.str, 0);
	}

	| ID  {
		makeCodeLoad($$.str, $1.str,1);
	}
;


fator: NUM  {
		
		makeCodeLoad($$.str, $1.str,0);
	}

	| ID  {

		makeCodeLoad($$.str, $1.str,1);
	}
	
	| '(' expressao_numerica ')'  {
		
		strcpy($$.str, $2.str);
	}
;


%%

void yyerror(char *s)
{
   fprintf(stderr, "Error: %s at line %d", s, count_lines);
   fprintf(stderr, "\n");
}

