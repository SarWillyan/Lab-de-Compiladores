run:
	$ bison -d trab1.y
	$ flex trab1.l
	$ gcc -c trab1.tab.c
	$ gcc -c lex.yy.c
	$ gcc -o comp lex.yy.o trab1.tab.o

clear:
	$ rm -f *.o *.h *.c comp 