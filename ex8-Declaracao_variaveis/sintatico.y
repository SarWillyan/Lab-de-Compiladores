%{
    #include <string.h>
    #include <stdio.h>
	#include "symbolTable.h"
	#include "codeGeneration.h"

    void yyerror(char*);
    int yylex();

    extern SymTable table;

    char s_decs[256];

%}

%union {
	struct code_t
	{
		char str[2044]; // string para o codigo asm
		int op; // opcoes (por exemplo nos jumps)
	} c;
}


%type <c> programa declaracoes declaracao bloco
%type <c> declaracao_inteiro declaracao_float declaracao_string
%type <c> comandos comando  comando_atribuicao
%type <c> expressao_numerica termo fator


%token <c> VAR ID NUM LITERAL_STR INT FLOAT STR WRITE READ WRITELN   
%left '+' '-'
%left '*' '/'


%%


programa: declaracoes bloco  {
		fprintf(out_file, "%s", $1.str);
		dumpCodeDeclarationEnd();
		fprintf(out_file, "%s", $2.str);
	}
;


declaracoes: declaracao declaracoes  {
		strcpy($$.str, $1.str);
		//printf("{%s}\n", $2.str);
		sprintf($$.str + strlen($$.str), "%s", $2.str);
	}

	| %empty { $$.str[0] = '\0'; }
;


declaracao: declaracao_inteiro { strcpy($$.str, $1.str); }
	| declaracao_float { strcpy($$.str, $1.str); }
	| declaracao_string { strcpy($$.str, $1.str); }
;


declaracao_inteiro: VAR ID ':' INT '=' NUM ';'  {
		addSymTable(&table, $2.str, INTEGER, $6.str);
		makeCodeDeclaration($$.str, $2.str, INTEGER, $6.str);
	}
	| VAR ID ':' INT ';'  {
		addSymTable(&table, $2.str, INTEGER, NULL);
		makeCodeDeclaration($$.str, $2.str, INTEGER, NULL);
	}
;


declaracao_float: VAR ID ':' FLOAT '=' NUM ';'  {
		addSymTable(&table, $2.str, REAL, $6.str);
		makeCodeDeclaration($$.str, $2.str, REAL, $6.str);
	}
	| VAR ID ':' FLOAT ';'  {
		addSymTable(&table, $2.str, REAL, NULL);
		makeCodeDeclaration($$.str, $2.str, REAL, NULL);
	}
;


declaracao_string: VAR ID ':' STR'=' LITERAL_STR ';'  {
		addSymTable(&table, $2.str, STRING, $6.str);
		makeCodeDeclaration($$.str, $2.str, STRING, $6.str);
	}
	| VAR ID ':' STR ';'  {
		addSymTable(&table, $2.str, STRING, NULL);
		makeCodeDeclaration($$.str, $2.str, STRING, NULL);
	}
;


bloco : '{' comandos '}'  {
		strcpy($$.str, $2.str);
	}
;


comandos : comando comandos  {
		sprintf($$.str + strlen($$.str), "%s", $2.str);
	}
	| %empty { $$.str[0] = '\0'; }
;


comando:  comando_atribuicao      { strcpy($$.str, $1.str); }
;

comando_atribuicao: ID '=' expressao_numerica ';'  {
		if (!makeCodeAssignment($$.str, $1.str, $3.str))
			YYABORT;
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
		if (!makeCodeLoad($$.str, $1.str, 1))
			YYABORT;
	}
;


fator: NUM  {
		makeCodeLoad($$.str, $1.str, 0);
	}
	| ID  {

		makeCodeLoad($$.str, $1.str, 1);
	}
	| '(' expressao_numerica ')'  {
		
		strcpy($$.str, $2.str);
	}
;


%%

void yyerror(char *s) {
   fprintf(stderr, "Error: %s at line %d", s, cont_lines);
   fprintf(stderr, "\n");
}
