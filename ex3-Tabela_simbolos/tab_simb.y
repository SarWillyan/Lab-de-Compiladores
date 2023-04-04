%token <num> INTEGER 
%token <id> VARIABLE 
%type <num> expr
%left '+' '-' 
%left '*' '/' 
%{
    #include <iostream>
    #include <string>
    #include <unordered_map>
    using std::string;
    using std::unordered_map;
    int yylex(void);
    int yyparse(void);
    void yyerror(const char *);
    unordered_map<string,int> variables;
%}

%union {
    int num;
    char id[16];
}

%% 

program: 
        program statement '\n' 
        |  
        ; 
statement: 
        expr                      { printf("%d\n", $1); } 
        | VARIABLE '=' expr       { printf("Atribuicao: idx_var=%s <- %d\n", $1, $3); variables[$1] = $3; } 
        ; 
expr: 
        INTEGER                   { $$ = $1;      }
        | VARIABLE                { $$ = variables[$1]; } 
        | expr '+' expr           { $$ = $1 + $3; } 
        | expr '-' expr           { $$ = $1 - $3; } 
        | expr '*' expr           { $$ = $1 * $3; } 
        | expr '/' expr           { $$ = $1 / $3; } 
        | '(' expr ')'            { $$ = $2; } 
        ; 
%% 

void yyerror(const char *s) { 
    printf("%s\n", s); 
    //return 0; 
} 

int main(void) { 
    yyparse(); 
    return 0; 
} 
