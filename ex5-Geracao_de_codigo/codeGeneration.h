#ifndef CODE_H
#define CODE_H

#include <stdio.h>
#include <stdlib.h>

// Tamanho de um string nao inicializada
#define STRING_SIZE 256

int makeCodeLoad(char* dest, char* item, int tipo);

void makeCodeAdd(char* dest, char* value);
void makeCodeSub(char* dest, char* value);
void makeCodeMul(char* dest, char* value2);
void makeCodeDiv(char* dest, char* value2);
void makeCodeMod(char* dest, char* value2);

#endif

