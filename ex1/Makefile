run:
	$ bison -d ex1.y
	$ flex ex1.l
	$ gcc -c ex1.tab.c 
	$ gcc -c lex.yy.c 
	$ gcc -o comp lex.yy.o ex1.tab.o

clean: 
	$ rm -f *.o *.c *.h comp