#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define TABLE_SIZE 300

typedef struct Variable
{
    int State;
    char Name[20];
    char Type[20];
    char Code[20];
    char Val[20];
} Variable;

typedef struct Key
{
    int State;
    char Name[20];
    char Type[20];
} Key;

typedef struct Op
{
    int State;
    char Name[20];
    char Type[30];
} Op;

typedef struct HashNode
{
    Variable Var;
    struct HashNode *suivant;
} HashNode, *PHashNode;

typedef struct ListKey
{
    struct Key key;
    struct ListKey *suivant;
} ListKey, *PlistKey;

typedef struct ListOp
{
    struct Op op;
    struct ListOp *suivant;
} ListOp, *PlistOp;

PHashNode HashTable[TABLE_SIZE] = {NULL};
PlistKey TeteKey = NULL;
PlistOp TeteOp = NULL;

int hashFunction(const char *key)
{
    unsigned int hash = 0;
    while (*key)
    {
        hash = (hash * 31) + *key;
        key++;
    }
    return hash % TABLE_SIZE;
}

void INSERTION_VAR(char Name[20], char Code[20], char Type[20], char Val[20])
{
    HashNode *P = (HashNode *)malloc(sizeof(HashNode));
    P->Var.State = 1;
    strcpy(P->Var.Name, Name);
    strcpy(P->Var.Type, Type);
    strcpy(P->Var.Code, Code);
    strcpy(P->Var.Val, Val);
    int index = hashFunction(Name);
    P->suivant = HashTable[index];
    HashTable[index] = P;
}
void INSERTION_KEY(char Name[20], char Type[20])
{
    PlistKey P;
    P = (ListKey *)malloc(sizeof(ListKey));
    P->key.State = 1;
    strcpy(P->key.Name, Name);
    strcpy(P->key.Type, Type);
    P->suivant = TeteKey;
    TeteKey = P;
}

void INSERTION_OP(char Name[20], char Type[20])
{
    PlistOp P;
    P = (ListOp *)malloc(sizeof(ListOp));
    P->op.State = 1;
    strcpy(P->op.Name, Name);
    strcpy(P->op.Type, Type);
    P->suivant = TeteOp;
    TeteOp = P;
}

void RECHERCHE_VAR(char Name[20], char Code[20], char Type[20], char Val[20])
{
    int index = hashFunction(Name);
    if (HashTable[index] != NULL)
    {
        bool Found = false;
        PHashNode P;
        P = HashTable[index];
        while (P != NULL && Found == false)
        {
            if (strcmp(Name, P->Var.Name) != 0)
            {
                P = P->suivant;
            }
            else
            {
                Found = true;
            }
        }
        if (Found == false)
        {
            INSERTION_VAR(Name, Code, Type, Val);
        }
    }
    else
    {
        INSERTION_VAR(Name, Code, Type, Val);
    }
}

void RECHERCHE_KEY(char Name[20], char Type[20])
{
    if (TeteKey != NULL)
    {
        bool Found = false;
        PlistKey P;
        P = TeteKey;
        while (P != NULL && Found == false)
        {
            if (strcmp(Name, P->key.Name) != 0)
            {
                P = P->suivant;
            }
            else
            {
                Found = true;
            }
        }
        if (Found == false)
        {
            INSERTION_KEY(Name, Type);
        }
    }
    else
    {
        INSERTION_KEY(Name, Type);
    }
}

void RECHERCHE_OP(char Name[20], char Type[20])
{
    if (TeteOp != NULL)
    {
        bool Found = false;
        PlistOp P;
        P = TeteOp;
        while (P != NULL && Found == false)
        {
            if (strcmp(Name, P->op.Name) != 0)
            {
                P = P->suivant;
            }
            else
            {
                Found = true;
            }
        }
        if (Found == false)
        {
            INSERTION_OP(Name, Type);
        }
    }
    else
    {
        INSERTION_OP(Name, Type);
    }
}

void AFFICHER_TABLE_VAR()
{

    printf("\n********************TABLE DES VARIABLES********************\n");
    printf(" _______________________________________________\n");
    printf("|   NomEntite   |  CodeEntite   |  TypeEntite   |\n");
    printf("|_______________|_______________|_______________|\n");
    int compteur = 0;
    int i;
    for (i = 0; i < TABLE_SIZE; i++)
    {
        PHashNode P = HashTable[i];
        while (P != NULL)
        {
            compteur++;
            printf("|%14s |%14s |%14s|\n", P->Var.Name, P->Var.Code, P->Var.Type);
            P = P->suivant;
        }
    }
    if (compteur == 0)
    {
        printf("\n*****TABLE DES VARIABLES EST VIDE******\n");
    }
    printf("|_______________|_______________|_______________|\n");
    printf("\n*****************************************************************\n\n");
}

void AFFICHER_TABLE_KEY()
{
    if (TeteKey == NULL)
    {
        printf("\n*****TABLE DES KEYWORDS EST VIDE******\n");
    }
    else
    {
        PlistKey P;
        P = TeteKey;
        printf("\n*******TABLE DES KEYWORDS********\n");
        printf(" _______________________________\n");
        printf("|   NomEntite   |  TypeEntite   |\n");
        printf("|_______________|_______________|\n");
        while (P != NULL)
        {
            printf("|%14s |%14s |\n", P->key.Name, P->key.Type);
            P = P->suivant;
        }
    }
    printf("|_______________|_______________|\n");
    printf("\n*********************************\n\n");
}

void AFFICHER_TABLE_OP()
{
    if (TeteOp == NULL)
    {
        printf("\n*****TABLE DES OPERATEURS EST VIDE******\n");
    }
    else
    {
        PlistOp P;
        P = TeteOp;
        printf("\n**********TABLE DES OPERATEURS************\n");
        printf(" ________________________________________\n");
        printf("|   NomEntite   |       TypeEntite       |\n");
        printf("|_______________|________________________|\n");
        while (P != NULL)
        {
            printf("|%14s |%22s |\n", P->op.Name, P->op.Type);
            P = P->suivant;
        }
    }
    printf("|_______________|________________________|\n");
    ;
    printf("\n*****************************************\n\n");
}

int NOT_DECLARED(char Name[20])
{
    int index = hashFunction(Name);
    PHashNode P = HashTable[index];
    int Found = 0;
    int not_declared = 0;
    while (P != NULL && Found == 0)
    {
        if (strcmp(P->Var.Name, Name) == 0)
        {
            Found = 1;
            if (strcmp(P->Var.Type, "") == 0)
            {
                not_declared = 1;
            }
        }
        P = P->suivant;
    }
    return not_declared;
}

int DOUBLE_DEC(char Name[20])
{
    int Double = 0;
    int Found = 0;
    int index = hashFunction(Name);
    PHashNode P = HashTable[index];
    while (P != NULL && Found == 0)
    {
        if (strcmp(P->Var.Name, Name) == 0)
        {
            Found = 1;
            if (strcmp(P->Var.Type, "") != 0)
            {
                Double = 1;
            }
        }
    }
    return Double;
}

void INSERTION_TYPE_IDF(char Name[20], char Type[20])
{
    int index = hashFunction(Name);
    PHashNode P = HashTable[index];
    int Found = 0;
    PHashNode Q = NULL;
    while (P != NULL && Found == 0)
    {
        if (strcmp(P->Var.Name, Name) == 0)
        {
            Found = 1;
            Q = P;
        }
        else
        {
            P = P->suivant;
        }
    }
    if (Q != NULL)
    {
        strcpy(Q->Var.Type, Type);
    }
}
