#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern int yyparse();

int main(int argc, char const *argv[])
{
	yyin = fopen(argv[1], "r");
    int ret = yyparse(); // chamada do analisador sintatico
    return ret;    
}



