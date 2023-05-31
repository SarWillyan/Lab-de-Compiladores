comp:  sintatico.tab.o  lex.yy.o main.o codeGeneration.o symbolTable.o
	gcc lex.yy.o sintatico.tab.o main.o codeGeneration.o symbolTable.o -o comp -g
	
lex.yy.o:   lex.yy.c
	gcc -c lex.yy.c -g
	
sintatico.tab.o:  sintatico.tab.c
	gcc -c sintatico.tab.c -g

lex.yy.c:  lexico.l
	flex lexico.l
	
sintatico.tab.c:   sintatico.y
	bison -d sintatico.y -o sintatico.tab.c
	
main.o:  main.c
	gcc -c main.c -g

codeGeneration.o: codeGeneration.c 
	gcc -c codeGeneration.c -g 
	
symbolTable.o: symbolTable.c
	gcc -c symbolTable.c -g

clear: 
	rm -f comp *.o *.yy.c *.tab.c *.tab.h *.asm
