/*
G = { {E,T,F,NUM}, {+,-,*,/,(,),0,1,2,3,4,5,6,7,8,9}, E, P}, onde 
P = {
    E --> E + T | E - T | T , 
    T --> T * F | T / F | F , 
    F --> ( E ) | NUM
    NUM --> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
}
*/
%{ 
    #include <stdio.h>
    int yylex(void); 
    void yyerror(char *); 
%} 
%token INTEGER 
%left   '+' '-' 
        '*' '/' 
        '(' ')'
%% 
program:
        program E '\n'       { printf("%d\n", $2); } 
	|  
        ; 
E: 
	E '+' T		  { $$ = $1 + $3; } 
	| E '-' T         { $$ = $1 - $3; } 
        | T
        ; 
T:      
        T '*' F           { $$ = $1 * $3; }
        | T '/' F         { $$ = $1 / $3; }
        | F
        ;
F:      
        INTEGER         { $$ = $1; }
        | '(' E ')'     { $$ = $2; }
        ;

%% 
void yyerror(char *s) { 
    printf( "%s\n", s); 
} 

int main(void) { 
    yyparse(); 
    return 0; 
} 
