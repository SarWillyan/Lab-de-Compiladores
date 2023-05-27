//Inclusao de bibliotecas
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbolTable.h"


//Funcao Hash
int hashFunction(int max_size, char* key) {
	int i = 0;
    int sum = 0;
    int factor = 0;
    while (key[i] != '\0') {
        sum += (key[i] + factor);
        factor += 113;
        i++;
    }

    // Metodo do resto da divisao
	return sum % max_size;
    
	// Metodo multiplicativo
	// double a = 0.6180339887; //constante de Knuth
	// a *= sum;
	// a = a - (int) a;
	// return (int)(a * max_size);
	
}

//Funcao que inicializa tabela Hash, colocando -1 em todos os numeros
int initSymTable(SymTable* table) {
    table->size = 0;
    table->max_size = MAX_SIZE_HASH_ARRAY;
    
    table->array = (SymTableNode*) malloc(table->max_size * sizeof(SymTableNode));
    if (table == NULL)
        return 0;
   
    // Inicializa cada posição do vetor
    for (int i = 0; i < table->max_size; i++)
    {
		table->array[i].data.identifier[0] = '\0';
        table->array[i].data.value = NULL;
        table->array[i].data.len_value = 0;
        
        table->array[i].next = NULL;
    }

    return 1;
}


// Funcao que realiza a impressao da Hash
void printSymTable(SymTable* table) {
	int i = 0;
	int cont = 0;
	
    while (i < table->max_size) {
		// Se nao tiver nada simplesmente imprime vazio
        if (table->array[i].data.identifier[0] == '\0')
			printf("[%d]: VAZIO\n", i);

        else { 
			SymTableNode *aux = &table->array[i];
			
			while (aux != NULL) {
				printf("[%d]: {%s} {%d} {%s}", i,
					aux->data.identifier, aux->data.type, aux->data.value);
			
				if (aux->next != NULL)
					printf("\n\t| ");

				aux = aux->next;
			}
			printf("\n");
		}
		i++;
	}
}


//Funcao de insercao na tabela Hash
int addSymTable(SymTable* table, char* identifier, Type type, char* value) {
	int pos;
	pos = hashFunction(table->max_size, identifier);
	
	SymTableNode* aux = NULL;

	// Verifica se a posicao esta livre
    if (table->array[pos].data.identifier[0] == '\0')
		aux = &table->array[pos];

    else {
		// verificando se ja nao se trata de uma dado repetido
        aux = &table->array[pos];
        while (aux != NULL && strcmp(aux->data.identifier, identifier) != 0)
            aux = aux->next;
        if (aux != NULL) return 0;

        aux = (SymTableNode*) malloc(sizeof(SymTableNode));
        if (aux == NULL) return 0;

        // A tabela passa a apontar para o aux alocado,
        // assim sempre será inserido no inicio e vai "empurrando a lista"
        aux->next = table->array[pos].next;
		table->array[pos].next = aux;
	}

	// Identifier
	strncpy(aux->data.identifier, identifier, MAX_SIZE_SYMBOL - 1);
	aux->data.identifier[MAX_SIZE_SYMBOL - 1] = '\0';

	// Type
	aux->data.type = type;

	// Value
	if (value != NULL) {
		int n = strlen(value);
		char* s = (char*) malloc((n + 1) * sizeof(char));
		if (s == NULL) return 0;

		strncpy(s, value, n);
		aux->data.value = s;
		aux->data.value[n] = '\0';

		// Comprimento da string value
		aux->data.len_value = n;
	}

	// Incrementa contador da quantidade de elementos na tabela
	table->size += 1;

    return 1;
}


//Função que realiza a busca pelo valor na hash
SymTableEntry* findSymTable(SymTable* table, char* identifier) {
    int pos = hashFunction(table->max_size, identifier); //descobrindo a posicao onde foi inserido

    SymTableNode *aux;
    aux = &(table->array[pos]);

    while ((aux != NULL) && (strcmp(aux->data.identifier, identifier) != 0))
        aux = aux->next;

    //Ele ira para por nao ter chegado em nulo e nao ter encontrado.
    if (aux == NULL)
        return NULL;
    else
        return &aux->data;
}


// //Função que realiza a remocao de um valor especifico
// int retiraValor( SymTableNode tabHash[],int valor,int qualHash){

//     int pos = funcaoHash(valor,qualHash); /*descobrindo a posicao do 
//     valor onde deseja remover*/

//     SymTableNode *aux;
//     aux =  (SymTableNode *) (tabHash[pos].next);

//     SymTableNode *auxAnt;
//     auxAnt = &(tabHash[pos]);
//     if (valor == auxAnt->dados.numero)
//     {
//     	if (aux != NULL )
//     	{
//     		*auxAnt = *aux;
//     		free(aux);
//     	}else
//     	{
//     		auxAnt->dados.numero = -1;
//     		auxAnt->next = NULL;
//     	}
//     	return 1;
//     }
//     while ( (aux != NULL) && (aux->dados.numero != valor) ){
//             auxAnt = aux;
//             aux = aux->next;
//     }
//     //Ele ira para por nao ter chegado em nulo e nao ter encontrado.
//     if (aux == NULL)
//         return 0;
//     else
//     { // ou se encontro:
//         auxAnt->next = aux->next;
//     	free(aux);
//         return 1; //retorna 1(verdadeiro) como encontrado.
//     }
// }



void freeSymTable(SymTable* table) {
	SymTableNode* node;
	SymTableNode* aux;
	for (int i = 0; i < table->max_size; i++) {
		aux = NULL;
		node = &table->array[i];
		if (node->data.identifier[0] != '\0') {
			free(node->data.value);
			node = node->next;

			while (node != NULL) {
				aux = node;
				node = node->next;

				free(aux->data.value);
				free(aux);
			}
		}
	}
	free(table->array);
}


// //Função que libera toda a mémoria alocada pela tabela e reinicializa ela
// void liberaTabela(SymTableNode* tab)
// {
//     SymTableNode* p,* ant;
//     int i;
    
//     for (i = 0; i < TAMTABELA; i++)
//     {
//         p = tab[i].next;
//         while (p != NULL)
//         {
//             ant = p;
//             p = p->next;
//             free(ant);
//         }

//         tab[i].dados.numero = -1;
//         tab[i].next = NULL;
//     }
// }
