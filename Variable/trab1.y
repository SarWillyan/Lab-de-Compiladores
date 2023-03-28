/*
 *  Para isso, considere a gramática:
 *   G = { {E,T,F,NUM}, {+,-,*,/,(,),0,1,2,3,4,5,6,7,8,9}, E, P}, onde 
 *   P = {
 *   E --> E + T | E - T | T , 
 *   T --> T * F | T / F | F , 
 *   F --> ( E ) | NUM
 *   NUM --> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
}*/

%{
        #include <stdio.h>
        int yylex(void);
        void yyerror(char *);
	int sym[26];
%}

%token INTEGER VARIABLE
%left '+' '-' 
%left '*' '/' 
%left '(' ')' 
%%
program: 
        program statment  '\n'	 
	|
        ; 

statment:
	E 			 { printf("%d\n", $1); }
	| VARIABLE '=' E	 { sym[$1] = $3; }
	;

E:
        T              
        | E '+' T       {$$ = $1 + $3;} 
        | E '-' T       {$$ = $1 - $3;}
        ;	

T:
        F                 
        | T '*' F         {$$ = $1 * $3;} 
        | T '/' F         {$$ = $1 / $3;} 
        ;
            
F:
        INTEGER           {$$ = $1;} 
        | '(' E ')'       {$$ = $2;} 
	| VARIABLE	  {$$ = sym[$1];}
        ;
%%

void yyerror(char *s) { 
    printf( "%s\n", s); 
} 

int main(void) { 
    yyparse(); 
    return 0; 
}


