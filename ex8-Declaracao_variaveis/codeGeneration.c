#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbolTable.h"
#include "codeGeneration.h"


// Codigo para declaracao de variaveis
void makeCodeDeclaration(char* dest, char* identifier, Type type, char* value) {
    if (type == INTEGER) {
        if (value == NULL)
        	sprintf(dest, "%s: dq 0\n", identifier);
        else {
        	int x = atoi(value);
            sprintf(dest, "%s: dq %d\n", identifier, x);
        }
    } else {
		printf("error: unknown type\n");
    }
}


// Termino da secao de dados e comeco da secao de codigo
void dumpCodeDeclarationEnd() {
    fprintf(out_file, "\nsection .text\n");
    fprintf(out_file, "global main\n");
    fprintf(out_file, "\nmain:\n");
}


int makeCodeAssignment(char* dest, char* id, char* expr) {   
    SymTableEntry* ret = findSymTable(&table, id);
    dest[0] = '\0';

    if (ret == NULL) {
        fprintf(stderr, "Error: %s not recognized at line %d\n", id, cont_lines);
        return 0;
    }

 
    if (ret->type == INTEGER) {
        sprintf(dest + strlen(dest), "%s", expr);
        sprintf(dest + strlen(dest), "pop rbx\n");
        sprintf(dest + strlen(dest), "mov [%s],rbx\n", ret->identifier);
    } else {
        fprintf(stderr, "Unsuported operation envolving string or float at line %d\n",
            cont_lines);
        return 0;
    }
    return 1;
}


int makeCodeLoad(char* dest, char* id, int ref) {
    dest[0] = '\0';

    if (ref == 0) {
        sprintf(dest + strlen(dest), "mov rbx,%s\n", id);
        sprintf(dest + strlen(dest), "push rbx\n");
        return 1;
    }

    SymTableEntry* ret = findSymTable(&table, id);

    if (ret == NULL) {
        fprintf(stderr, "Error: %s not recognized at line %d\n", id, cont_lines);
        return 0;
    }
   
    sprintf(dest + strlen(dest), "mov rbx,[%s]\n", ret->identifier);
    sprintf(dest + strlen(dest), "push rbx\n");
    return 1;
}


void makeCodeAdd(char* dest, char* value) {
    sprintf(dest + strlen(dest), "%s", value);
    sprintf(dest + strlen(dest), "pop rcx\n");
    sprintf(dest + strlen(dest), "pop rbx\n");
    sprintf(dest + strlen(dest), "add rbx,rcx\n");
    sprintf(dest + strlen(dest), "push rbx\n");
}


void makeCodeSub(char* dest, char* value) {   
    sprintf(dest + strlen(dest), "%s", value);
    sprintf(dest + strlen(dest), "pop rcx\n");
    sprintf(dest + strlen(dest), "pop rbx\n");
    sprintf(dest + strlen(dest), "sub rbx,rcx\n");
    sprintf(dest + strlen(dest), "push rbx\n");

}

void makeCodeMul(char* dest, char* value2) {
    sprintf(dest + strlen(dest), "%s", value2);
    sprintf(dest + strlen(dest), "pop rcx\npop rbx\nimul rbx,rcx\npush rbx\n");
}


void makeCodeDiv(char* dest, char* value2) {
    sprintf(dest + strlen(dest), "%s", value2);
    sprintf(dest + strlen(dest), "pop r8\n");
    sprintf(dest + strlen(dest), "pop rax\n");
    sprintf(dest + strlen(dest), "xor rdx,rdx\n");
    sprintf(dest + strlen(dest), "idiv r8\n");
    sprintf(dest + strlen(dest), "push rax\n");
}


void makeCodeMod(char* dest, char* value2) {
    sprintf(dest + strlen(dest), "%s", value2);
    sprintf(dest + strlen(dest), "pop r8\n");
    sprintf(dest + strlen(dest), "pop rax\n");
    sprintf(dest + strlen(dest), "xor rdx,rdx\n");
    sprintf(dest + strlen(dest), "idiv r8\n");
    sprintf(dest + strlen(dest), "push rdx\n");
}
