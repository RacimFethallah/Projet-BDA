%{
#include "synt.tab.h"
#include "TS.h"	
extern nb_ligne;
extern col;
extern YYSTYPE yylval;
%}

lettreM [A-Z]
lettre [a-zA-Z]
chiffre [0-9]
IDF {lettre}({lettre}|{chiffre})*
INTEGER {chiffre}+|"\("[+-]{chiffre}+"\)"
FLOAT {chiffre}+.{chiffre}+|"\("[+-]{chiffre}+.{chiffre}+"\)"
Comment %%.*
CONST {FLOAT}|{INTEGER}
STRING \".+\"
%%

VAR_GLOBAL   {col = col + strlen(yytext) ;strcpy(yylval.chaine , yytext);RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext);return mc_VAR_GLOBAL; }
DECLARATION { col = col + strlen(yytext) ;strcpy(yylval.chaine , yytext);RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext);return mc_DECLARATION; }
INSTRUCTION { col = col + strlen(yytext) ;strcpy(yylval.chaine , yytext);RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext);return mc_INSTRUCTION; }

INTEGER {col = col + strlen(yytext) ;strcpy(yylval.chaine , yytext);RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext); return mc_INTEGER;}
FLOAT {col = col + strlen(yytext) ;strcpy(yylval.chaine , yytext);RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext); return mc_FLOAT;}
CONST {col = col + strlen(yytext) ;strcpy(yylval.chaine , yytext);RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext); return mc_CONST;}

IF {col = col + strlen(yytext) ;RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext); return IF;}
ELSE {col = col + strlen(yytext) ;RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext); return ELSE;}

WHILE {col = col + strlen(yytext) ;RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext); return WHILE;}
FOR {col = col + strlen(yytext) ;RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext); return FOR;}
READ {col = col + strlen(yytext) ;RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext); return READ;}
WRITE {col = col + strlen(yytext) ;RECHERCHE_KEY(yytext,"Keyword"); printf("Keyword %s reconnu\n",yytext); return WRITE;}

{IDF} {if (yyleng <=7) {col = col+ strlen(yytext); printf("IDF reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_VAR(yytext ,"idf","",""); return IDF;}
      else {col = col + strlen(yytext); printf("ERREUR ligne :%d  et colonne :%d  IDF %s est tres long\n",nb_ligne,col, yytext);}}

{INTEGER} {printf("INTEGER reconnu\n");if(atoi(yytext)<-32768 || atoi(yytext)>32767){printf("erreur lexical entier trop long a la ligne %d\n",nb_ligne);}else{yylval.entier=atoi(yytext);RECHERCHE_VAR(yytext ,"entier","INTEGER",yytext);}return INTEGER;}
{FLOAT} {printf("FLOAT reconnu\n");yylval.reel=atof(yytext);RECHERCHE_VAR(yytext ,"reel","FLOAT",yytext);return FLOAT;}
{STRING} {printf("STRING reconnu\n");return STRING;}
{Comment} {col = col + strlen(yytext);printf("Commentaire reconnu \n");}

"=" {printf("Operateur Affectation reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur affectation"); return aff;}
"{" {printf("Accolade ouvrante reconnu\n");RECHERCHE_OP(yytext,"acolade ouvrante"); return ouvracc;}
"}" {printf("Accolade fermante reconnu\n");RECHERCHE_OP(yytext,"acolade fermante"); return feracc;}
"[" {printf("Crochet ouvrant reconnu\n");RECHERCHE_OP(yytext,"crochet ouvrant"); return ouvrc;}
"]" {printf("Crochet fermant reconnu\n");RECHERCHE_OP(yytext,"crochet fermant"); return ferc;}
"(" {printf("Parenthese ouvrante reconnu\n");RECHERCHE_OP(yytext,"parenthese ouvrante"); return ouvrp;}
")" {printf("Parenthese fermante reconnu\n");RECHERCHE_OP(yytext,"parenthese fermante"); return ferp;}


"+" {printf("Operateur Addition reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur d'add"); return add;}
"-" {printf("Operateur Soustraction reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur de soustr"); return sous;}
"*" {printf("Operateur Multiplication reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur de mult"); return mul;}
"/" {printf("Operateur Division reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur de div"); return divs;}


"&&" {printf("Operateur AND reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"op logique et"); return and;}
"||" {printf("Operateur OR reconnu\n");strcpy(yylval.chaine , yytext); RECHERCHE_OP(yytext,"op logique ou");return or;}
"!"  {printf("Operateur NOT reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"op logique negation"); return not;}

">" {printf("Operateur Superieur reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur superieur"); return sup;}
"<" {printf("Operateur Inferieur reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur inferieur"); return inf;}
">=" {printf("Operateur Superieur ou egal reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur superieur ou egal"); return supEg;}
"<=" {printf("Operateur Inferieur ou egal reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur inferieur ou egal"); return infEg;}
"==" {printf("Operateur Egalite reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur egalitee"); return egl;}
"!=" {printf("Operateur Different reconnu\n");strcpy(yylval.chaine , yytext);RECHERCHE_OP(yytext,"operateur different de"); return diff;}
":" {printf("DEUX_Points reconnus\n");RECHERCHE_OP(yytext,"operateur deux points"); return points;}
"," {printf ("Vergule reconnue \n") ;RECHERCHE_OP(yytext,"operateur virgule"); return vrg;}
";" {printf ("Point-Vergule reconnu \n") ; RECHERCHE_OP(yytext,"operateur point virgule");return pvg;}

[ \t]  {col = col + strlen(yytext);}
\n   {col =1; nb_ligne++;}
. {printf("Erreur Lexicale!! Verifier la ligne %d ,la colonne %d entite %s \n", nb_ligne, col, yytext);}
