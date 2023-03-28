run:
	$ bison -d gram.y
	$ flex -i gram.l
	$ gcc -c gram.tab.c 
	$ gcc -c lex.yy.c 
	$ gcc -o comp lex.yy.o gram.tab.o

clear: 
	$ rm -f *.o *.h *.c comp
