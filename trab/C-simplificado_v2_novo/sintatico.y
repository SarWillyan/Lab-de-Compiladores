%{
    #include <string.h>
    #include <stdio.h>
	#include "symbolTable.h"
	#include "codeGeneration.h"	
	#define TRUE 1
	#define FALSE 0

    void yyerror(char*);
    int yylex();

    extern SymTable tableGlobal;
	extern SymTable tableLocal;

    char s_decs[256];
	int local = FALSE;
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
%type <c> comandos comando comando_escrita comando_leitura comando_atribuicao
%type <c> expressao_numerica termo fator
%type <c> expressao_booleana operador_relacional
%type <c> comando_se comando_se_senao comando_enquanto

%token <c> ID NUM_INT NUM_FLOAT LITERAL_STR INT FLOAT STR WRITE READ WRITELN IF ELSE WHILE
%token <c> LE GE EQ NE

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

	| %empty { $$.str[0] = '\0'; 
			   local = TRUE;
			 }
;


declaracao: declaracao_inteiro { strcpy($$.str, $1.str); }
	| declaracao_float { strcpy($$.str, $1.str); }
	| declaracao_string { strcpy($$.str, $1.str); }
;


declaracao_inteiro: INT ID '=' NUM_INT ';'  {

		if (local == FALSE ) {
			addSymTable(&tableGlobal, $2.str, INTEGER, $4.str);
			makeCodeDeclaration($$.str, $2.str, INTEGER, $4.str);
		} else {
			addSymTable(&tableLocal, $2.str, INTEGER, $4.str);
			makeCodeDeclaration($$.str, $2.str, INTEGER, $4.str);
		}
	}

	| INT ID ';'  {

		if (local == FALSE) {
			addSymTable(&tableGlobal, $2.str, INTEGER, NULL);
			makeCodeDeclaration($$.str, $2.str, INTEGER, NULL);
		} else { 
			addSymTable(&tableLocal, $2.str, INTEGER, NULL);
			makeCodeDeclaration($$.str, $2.str, INTEGER, NULL);
		}
	}
;


declaracao_float: FLOAT ID '=' NUM_FLOAT ';'  {

		if (local == FALSE) {
			addSymTable(&tableGlobal, $2.str, REAL, $4.str);
			makeCodeDeclaration($$.str, $2.str, REAL, $4.str);
		} else {
			addSymTable(&tableLocal, $2.str, REAL, $4.str);
			makeCodeDeclaration($$.str, $2.str, REAL, $4.str);
		}

	}

	| FLOAT ID';'  {

		if (local == FALSE) {
			addSymTable(&tableGlobal, $2.str, REAL, NULL);
			makeCodeDeclaration($$.str, $2.str, REAL, NULL);
		} else {
			addSymTable(&tableLocal, $2.str, REAL, NULL);
			makeCodeDeclaration($$.str, $2.str, REAL, NULL);
		}
	}
;


declaracao_string: STR ID '=' LITERAL_STR ';'  {

		if (local == FALSE) {
			addSymTable(&tableGlobal, $2.str, STRING, $4.str);
			makeCodeDeclaration($$.str, $2.str, STRING, $4.str);
		} else {
			addSymTable(&tableLocal, $2.str, STRING, $4.str);
			makeCodeDeclaration($$.str, $2.str, STRING, $4.str);
		}
	}

	| STR ID ';'  {
		if (local == FALSE) {
			addSymTable(&tableGlobal, $2.str, STRING, NULL);
			makeCodeDeclaration($$.str, $2.str, STRING, NULL);
		} else {
			addSymTable(&tableLocal, $2.str, STRING, NULL);
			makeCodeDeclaration($$.str, $2.str, STRING, NULL);
		}
	}
;


bloco : '{' comandos '}'  {

		strcpy($$.str, $2.str);
	}
;


comandos : comando comandos  {
       strcpy($$.str, $1.str);
		sprintf($$.str + strlen($$.str), "%s", $2.str);
	}

	| %empty { $$.str[0] = '\0'; }
;


comando: comando_escrita      { strcpy($$.str, $1.str); }
	| comando_leitura         { strcpy($$.str, $1.str); }
	| comando_atribuicao      { strcpy($$.str, $1.str); }
	| comando_se              { strcpy($$.str, $1.str); }
	| comando_se_senao        { strcpy($$.str, $1.str); }
	| comando_enquanto        { strcpy($$.str, $1.str); }
	| declaracao
;


comando_leitura: READ '(' ID ')' ';'  {
		
		if (!makeCodeRead($$.str, $3.str, 0))
			YYABORT;
	}

	| READ '(' LITERAL_STR ')' ';'  {
		
		if (!makeCodeRead($$.str, $3.str, 2))
			YYABORT;
	}
;


comando_escrita: WRITE '(' ID ')' ';'  {

		if (!makeCodeWrite($$.str, $3.str, 0))
			YYABORT;
	}

	| WRITELN '(' ID ')' ';'  {

		if (!makeCodeWrite($$.str, $3.str, 1))
			YYABORT;
	}

	| WRITE '(' LITERAL_STR ')' ';'  {

		if (!makeCodeWrite($$.str, $3.str, 2))
			YYABORT;
	}

	| WRITELN '(' LITERAL_STR ')' ';'  {

		if (!makeCodeWrite($$.str, $3.str, 2))
			YYABORT;
	}
;


comando_atribuicao: ID '=' expressao_numerica ';'  {
		
		if (!makeCodeAssignment($$.str, $1.str, $3.str))
			YYABORT;
	}

	| ID '=' LITERAL_STR ';'  {
		
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



termo: NUM_INT  {

		makeCodeLoad($$.str, $1.str, 0);
	}

	| NUM_FLOAT  {

		makeCodeLoad($$.str, $1.str, 0);
	}

	| ID  {

		if (!makeCodeLoad($$.str, $1.str, 1))
			YYABORT;

	}
;


fator: NUM_INT  {
		
		makeCodeLoad($$.str, $1.str, 0);
	}

	| NUM_FLOAT  {

		makeCodeLoad($$.str, $1.str, 0);
	}

	| ID  {

		makeCodeLoad($$.str, $1.str, 1);
	}
	
	| '(' expressao_numerica ')'  {
		
		strcpy($$.str, $2.str);
	}
;




comando_se: IF '(' expressao_booleana ')' bloco  {
		
		makeCodeIf($$.str, $3.str, $3.op, $5.str);
	}
;


comando_se_senao: IF '(' expressao_booleana ')' bloco ELSE bloco  {

		makeCodeIfElse($$.str, $3.str, $3.op, $5.str, $7.str);
	}
;


comando_enquanto: WHILE '(' expressao_booleana ')' bloco  {

		makeCodeWhile($$.str, $3.str, $3.op, $5.str);
	}
;


expressao_booleana: ID operador_relacional expressao_numerica  {
		
		$$.op = $2.op;
		if (!makeCodeComp($$.str, $1.str, $3.str))
			YYABORT;
	}
;

operador_relacional: '<'   { $$.op = -4; }
	| '>'                  { $$.op = -3; }
	| LE                   { $$.op = 3; }
	| GE                   { $$.op = 4; }
	| EQ                   { $$.op = -2; }
	| NE                   { $$.op = 2; }
;




%%

void yyerror(char *s)
{
   fprintf(stderr, "Error: %s at line %d", s, cont_lines);
   fprintf(stderr, "\n");
}

