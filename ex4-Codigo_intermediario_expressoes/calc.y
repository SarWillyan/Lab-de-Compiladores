

%{
#include <string.h>
#include <stdio.h>
int yyerror(char *);
int yylex(void);

void newtemp (char *label)
{
  static int label_count = 0;
  sprintf(label,"t%d",label_count);
  label_count++;
}


%}

%left '+' '-'
%left '*' '/'

%union {
  struct sCode {
    char code[2048];
    char temp[32];
    } attribute;

};

%token <attribute> VARIABLE;
%token <attribute> INTEGER;
%type <attribute> program statement expr 

%%
program:  program statement '\n' {printf("%s\n", $2.code);}
| %empty {}
;
statement: expr   { strcpy($$.code,$1.code); }
| VARIABLE '=' expr  { strcpy($$.code,$1.temp);
                       strcat($$.code, "=");
                       strcat($$.code, $3.code);   }
;


expr:
INTEGER   { newtemp($$.temp);
            strcpy ($$.code,$$.temp);
            strcat ($$.code,"=");
            strcat ($$.code,$1.temp);
            strcat ($$.code,"\n");
           }
| VARIABLE { strcpy ($$.temp,$1.temp);   
             strcat ($$.temp,"\n");
            }
| expr '+' expr { newtemp($$.temp); 
                  strcpy ($$.code, $1.code);
				          strcat ($$.code,$3.code);
                  strcat ($$.code,$$.temp);
                  strcat ($$.code,"=");
                  strcat ($$.code,$1.temp);
                  strcat ($$.code,"+");
                  strcat ($$.code,$3.temp);
					        strcat ($$.code,"\n");
                }
| expr '-' expr { newtemp($$.temp); 
                  strcpy ($$.code, $1.code);
				          strcat ($$.code,$3.code);
                  strcat ($$.code,$$.temp);
                  strcat ($$.code,"=");
                  strcat ($$.code,$1.temp);
                  strcat ($$.code,"-");
                  strcat ($$.code,$3.temp);
					        strcat ($$.code,"\n");
                }
| expr '*' expr { newtemp($$.temp); 
                  strcpy ($$.code, $1.code);
				          strcat ($$.code,$3.code);
                  strcat ($$.code,$$.temp);
                  strcat ($$.code,"=");
                  strcat ($$.code,$1.temp);
                  strcat ($$.code,"*");
                  strcat ($$.code,$3.temp); 
                  strcat ($$.code,"\n");					
                }
| expr '/' expr { newtemp($$.temp); 
                  strcpy ($$.code, $1.code);
				          strcat ($$.code,$3.code);
                  strcat ($$.code,$$.temp);
                  strcat ($$.code,"=");
                  strcat ($$.code,$1.temp);
                  strcat ($$.code,"/");
                  strcat ($$.code,$3.temp); 
					        strcat ($$.code,"\n");
                }
| '(' expr ')'  {
                  strcpy ($$.temp, $2.temp);
                  strcpy ($$.code,$2.code);
                }
;

%%
int yyerror(char *s) {
printf("%s\n", s);
return 0;
}
int main(void) {
yyparse();
return 0;
}