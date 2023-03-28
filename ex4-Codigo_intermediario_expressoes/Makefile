calc:  calc.tab.o  lex.yy.o 
	gcc lex.yy.o calc.tab.o  -o calc
	
	
lex.yy.o:   lex.yy.c
	gcc -c lex.yy.c
	
calc.tab.o:  calc.tab.c
	gcc -c calc.tab.c

lex.yy.c:  calc.l
	flex calc.l

	
calc.tab.c:   calc.y
	bison -d calc.y -o calc.tab.c
	
