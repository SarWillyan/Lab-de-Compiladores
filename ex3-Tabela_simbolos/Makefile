run:
	$ bison -d tab_simb.y
	$ flex -i tab_simb.l
	$ g++ -c tab_simb.tab.c 
	$ g++ -c lex.yy.c 
	$ g++ -o comp lex.yy.o tab_simb.tab.o

clear: 
	$ rm -f *.o *.h *.c comp
