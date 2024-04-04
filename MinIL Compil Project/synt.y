%{  
    #include<string.h>
    int nb_ligne=1,col=1;
    int op;
    int constante;
    char Type_Idf[20];
    
%}
%union{  
    char chaine[20];
    int entier;
    float reel;
}
%token <chaine>mc_VAR_GLOBAL <chaine>mc_DECLARATION <chaine>mc_INSTRUCTION
%token <chaine>IDF <entier>INTEGER <reel>FLOAT <chaine>mc_INTEGER <chaine>mc_FLOAT <chaine>mc_CONST 
%token WHILE FOR IF ELSE and or not READ WRITE
%token feracc ouvracc ferc ouvrc ouvrp ferp vrg pvg points STRING
%token <chaine>aff <chaine>add <chaine>sous <chaine>mul <chaine>divs
%token <chaine>sup <chaine>supEg <chaine>inf <chaine>infEg <chaine>egl <chaine>diff
%start S
%right aff
%left or
%left and
%left sup supEg egl diff infEg inf
%left add sous
%left mul divs
%%
S:mc_VAR_GLOBAL ouvracc DEC feracc mc_DECLARATION ouvracc DEC feracc mc_INSTRUCTION ouvracc INST feracc{ printf("\n*****************************************************************\n");
            printf("                 Code Correct Syntaxiquement\n");
            printf("*****************************************************************\n");
            YYACCEPT;} 
;

DEC:TYPE DEC_IDF DEC|
;

TYPE:mc_INTEGER{strcpy(Type_Idf , $1);}
|mc_FLOAT{strcpy(Type_Idf , $1);}|mc_CONST{constante=1;}
;

DEC_IDF:IDF pvg{
   /* if(DOUBLE_DEC($1)==1) {printf("erreur semantique: double declaration de %s a la ligne %d\n",$1,nb_ligne);}
    else {INSERTION_TYPE_IDF($1 ,Type_Idf);} */ }
|IDF vrg DEC_IDF|DEC_TAB pvg|IDF aff INTEGER pvg|IDF aff FLOAT pvg
;

DEC_TAB:IDF ouvrc INTEGER ferc{
  /*  if(DOUBLE_DEC($1)==1) {printf("erreur semantique: double declaration de %s a la ligne %d\n",$1,nb_ligne);}
    else {INSERTION_TYPE_IDF($1 ,Type_Idf);}
; */}
boucle_while:D bloc_instructions
;

D:WHILE ouvrp condition ferp 
;

boucle_for:FOR ouvrp IDF points INTEGER points INTEGER points IDF ferp bloc_instructions
;
entree_sortie : READ ouvrp IDF ferp pvg | WRITE ouvrp STRING ferp pvg|WRITE ouvrp STRING vrg IDF vrg STRING ferp pvg
;
bloc_instructions:ouvracc INST feracc   
;

INST:INST_Basic INST|boucle_for INST|boucle_while INST|INST_IF INST|
;
INST_Basic:entree_sortie|AFFECTATION 
;

condition:not condition|COND_CMP|COND_LOG|not IDF
;
COND_CMP:OPERANDE OP_CMP 
;
OP_CMP:sup{op=1;}OPERANDE
|supEg{op=1;}OPERANDE
|inf{op=1;}OPERANDE
|infEg{op=1;}OPERANDE
|egl{op=1;}OPERANDE
|diff{op=1;}OPERANDE
;

AFFECTATION:OPERANDE aff OPERANDE pvg
;

INST_AR:OPERANDE add OPERANDE{op=1;}
|OPERANDE sous OPERANDE{op=1;}
|OPERANDE mul OPERANDE{op=1;}
|OPERANDE divs OPERANDE{op=0;}
;
INST_IF:B ELSE bloc_instructions
;
B:A bloc_instructions
;
A:IF ouvrp condition ferp 
;

COND_LOG:OPERANDE OP_LOG OPERANDE
;
OP_LOG:and|or
;


element:IDF{if(NOT_DECLARED($1)==1){
  //  printf("\nerreur semantique , idf non declaree a la ligne %d\n",nb_ligne);
}
}
|INTEGER{
    if(op==0 && $1==0){
       // printf("erreur semantique: division par zero a la ligne %d\n",nb_ligne);
    } 
    }
|FLOAT|INST_AR|AFFECTATION|COND_CMP
|IDF ouvrc IDF ferc
;
OPERANDE:element|ouvrp element ferp;


%%

int yyerror(char *msg)
{ printf("%s ERROR ! :Erreur Syntaxique a ligne %d a colonne %d \n ", nb_ligne,col);
 }
main () 
{
    yyparse();
   // AFFICHER_TABLE_KEY();
   // AFFICHER_TABLE_OP(); 
   // AFFICHER_TABLE_VAR();
}
yywrap(){} 

