

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "codeGeneration.h"


int makeCodeLoad(char* dest, char* item, int tipo)
{
    dest[0] = '\0';
    if (item != NULL) {
		if (tipo == 0) {
          sprintf(dest + strlen(dest), "mov rax,%s\n", item);
          sprintf(dest + strlen(dest), "push rax\n");
          return 1;
		}
		else {
	       sprintf(dest + strlen(dest), "mov rax,[%s]\n", item);
          sprintf(dest + strlen(dest), "push rax\n");
          return 1;		
			
		}
    }

    return 0;
}


void makeCodeAdd(char* dest, char* value)
{
    sprintf(dest + strlen(dest), "%s", value);
    sprintf(dest + strlen(dest), "pop rcx\n");
    sprintf(dest + strlen(dest), "pop rbx\n");
    sprintf(dest + strlen(dest), "add rbx,rcx\n");
    sprintf(dest + strlen(dest), "push rbx\n");
}


void makeCodeSub(char* dest, char* value)
{   
    sprintf(dest + strlen(dest), "%s", value);
    sprintf(dest + strlen(dest), "pop rcx\n");
    sprintf(dest + strlen(dest), "pop rbx\n");
    sprintf(dest + strlen(dest), "sub rbx,rcx\n");
    sprintf(dest + strlen(dest), "push rbx\n");

}

void makeCodeMul(char* dest, char* value2)
{
    sprintf(dest + strlen(dest), "%s", value2);
    sprintf(dest + strlen(dest), "pop rcx\npop rbx\nimul rbx,rcx\npush rbx\n");
}


void makeCodeDiv(char* dest, char* value2)
{
    sprintf(dest + strlen(dest), "%s", value2);
    sprintf(dest + strlen(dest), "pop r8\n");
    sprintf(dest + strlen(dest), "pop rax\n");
    sprintf(dest + strlen(dest), "xor rdx,rdx\n");
    sprintf(dest + strlen(dest), "idiv r8\n");
    sprintf(dest + strlen(dest), "push rax\n");
}


void makeCodeMod(char* dest, char* value2)
{
    sprintf(dest + strlen(dest), "%s", value2);
    sprintf(dest + strlen(dest), "pop r8\n");
    sprintf(dest + strlen(dest), "pop rax\n");
    sprintf(dest + strlen(dest), "xor rdx,rdx\n");
    sprintf(dest + strlen(dest), "idiv r8\n");
    sprintf(dest + strlen(dest), "push rdx\n");
}

