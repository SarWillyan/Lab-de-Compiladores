# Implentação de um Compilador 

## Para isso, considere a gramática:

~~~ 
G = { {E,T,F,NUM}, {+,-,*,/,(,),0,1,2,3,4,5,6,7,8,9}, E, P}, onde 

P = {
    E --> E + T | E - T | T , 
    T --> T * F | T / F | F , 
    F --> ( E ) | NUM
    NUM --> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
}
~~~

Portanto, o compilador resultante reconhecerá qualquer expressão aritmética com números inteiros, apresentando/imprimindo o resultado da expressão de tal modo que obedeça a precedência entre operadores e parênteses.