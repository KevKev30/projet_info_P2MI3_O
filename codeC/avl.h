#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct Station{
    int identifiant;
    long int capacite;
    long int somme_conso;
}Station;


typedef struct AVL{
    Station station;
    int equilibre;
    struct AVL * fd;
    struct AVL * fg;
}AVL;


int max(int a, int b);
int min(int a, int b);
int max3(int a, int b, int c);
int min3(int a, int b, int c);
AVL * creerAVL(Station e);
AVL * rotationGauche(AVL * a);
AVL * rotationDroite(AVL * a);
AVL * doubleRotationGauche(AVL * a);
AVL * doubleRotationDroite(AVL * a);
AVL * equilibreAVL(AVL * a);
AVL * insertionAVL(AVL * a, Station e, int * h);
void libererAVL(AVL * a);
void recherche(AVL * a, Station e);
void afficherStation(AVL * a);
