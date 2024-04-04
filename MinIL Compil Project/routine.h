#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#include<string.h>
extern int qc;
extern char Chaine[20];
typedef struct quadr{
    char operateur[20];
    char operande1[20];
    char operande2[20];
    char resultat[20];
    struct quadr* suivant;
}quadr,*pquadr;

pquadr Tete=NULL;
 int i=1;
extern int fin_if[10000];
extern int qc_if[10000];
extern int debw[10000];
extern int finw[10000];
extern int bzw[10000];
extern int K;
extern int j;
extern int J;

void AJOUTER_QUAD(char Op[20] , char Op1[20] , char Op2[20],char Res[20]) {
    if(Tete==NULL) {
    Tete=(quadr*)malloc(sizeof(quadr));
    strcpy(Tete->operateur,Op);
    strcpy(Tete->operande1,Op1);
    strcpy(Tete->operande2,Op2);
    strcpy(Tete->resultat,Res);
    Tete->suivant=NULL;
    }
    else {   
    pquadr P;
    P=(quadr*)malloc(sizeof(quadr));
    strcpy(P->operateur,Op);
    strcpy(P->operande1,Op1);
    strcpy(P->operande2,Op2);
    strcpy(P->resultat,Res);
    pquadr Q;
    Q=Tete;
    while(Q->suivant!=NULL){
        Q=Q->suivant;
    }
    Q->suivant=P;
    P->suivant=NULL;
    }
    qc++;
    i=qc;
    if(strcmp( Op, "oper.inst1")==0) {
        j++;
        qc_if[j]=qc+1;
    }
    if(strcmp(Op , "oper.inst.while")==0) {
        finw[J]=qc+1;
    }
    if(strcmp(Op , "oper.inst2")==0) {
        fin_if[j]=qc+1;
    }
    if(strcmp(Op1 , "fin_while")==0) {
        bzw[J]=qc;
    }
    if(strcmp(Op , "oper.cond.while")==0) {
        J++;
        debw[J]=qc;
    }
} 

void MODIFIER_CHAMP(int Champ , pquadr P,char Val[20]) {
 if(P!=NULL) {
       switch(Champ) {
        case 1:strcpy(P->operateur,Val);  break;
        case 2:strcpy(P->operande1,Val);  break;
        case 3: strcpy(P->operande2,Val); break;
        case 4:strcpy(P->resultat,Val);  break;
        default:;
    }
 }
}

void MODIFIER_QUAD(int Pos,int Champ , char Val[20]){
    int i;
    pquadr P;
    if(Pos==1) {
        MODIFIER_CHAMP(Champ,Tete,Val);
    } else {
        P=Tete;
        i=1;
        while(i<Pos && P!=NULL) {
                P=P->suivant;
                i++;
        }
        if(P!=NULL) {
            
            MODIFIER_CHAMP(Champ,P,Val);
        }
    }
}


 void AFFICHER_QUAD() {
    printf("\n\n ********LES QUADRUPLES SONT :**********\n");
    pquadr P=Tete;
    int K=1;
    while(P!=NULL && K<=i) {
        printf("\n%d - (%s , %s , %s , %s)\n",K,P->operateur , P->operande1,P->operande2,P->resultat);
        P=P->suivant;
        K++; 
    }
} 

