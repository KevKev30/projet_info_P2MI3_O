#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct consommateur{
    int identitfiant;
    int conso;
}consommateur;

typedef struct station{
    int identifiant;
    int capacite;
    int somme_conso;
}station;
