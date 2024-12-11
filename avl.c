#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "avl.h"

int max(int a, int b){
    if (a<b){
        return b;
    }
    return a;
}


int min(int a, int b){
    if (a>b){
        return b;
    }
    return a;
}


int max3(int a, int b, int c){
    return max(max(a, b), c);
}


int min3(int a, int b, int c){
    return min(min(a, b), c);
}


AVL * creerAVL(Station e){
    AVL * a = (AVL*) * malloc(sizeof(AVL));
    if (a==NULL){
        exit(0);
    }
    a->station.identifiant = e->identifiant;
    a->station.capacite = e->capacite;
    a->station.somme_conso = e->somme_conso;
    a->eq = 0;
    a->fg = NULL;
    a->fd = NULL;
    return a;
}


AVL * rotationGauche(AVL * a){
    AVL * pivot = a->fd;
    int eqa, eqp;

    a->fd = pivot->fg;
    pivot->fg = a;

    eqa = a->eq;
    eqp = pivot->eq;

    a->eq = eqa - max(eqp, 0) - 1;
    pivot->eq = min3(eqa-2, eqp+eqa-2, eqp-1);

    return pivot;
}


AVL * rotationDroite(AVL * a){
    AVL * pivot = a->fg;
    int eqa, eqp;

    a->fg = pivot->fd;
    pivot->fd = a;

    eqa = a->eq;
    eqp = pivot->eq;

    a->eq = eqa - min(eqp, 0) + 1;
    pivot->eq = max3(eqa+2, eqp+eqa+2, eqp+1);

    return pivot;
}


AVL * doubleRotationGauche(AVL * a){
    a->fd = rotationDroite(a->fd);
    return rotationGauche(a);
}


AVL * doubleRotationDroite(AVL * a){
    a->fg = rotationGauche(a->fg);
    return rotationDroite(a);
}


AVL * equilibreAVL(AVL * a){
    if(a->eq <= -2){
        if(a->fg->eq <= 0){
            return rotationDroite(a);
        }
        else{
            return doubleRotationDroite(a);
        }
    }
    else if(a->eq >= 2){
        if(a->fg->eq >= 0){
            return rotationGauche(a);
        }
        else{
            return doubleRotationGauche(a);
        }
    }
    return a;
}

AVL * insertionAVL(AVL * a, Station e, int *h){
    if (a == NULL){
        *h = 1;
        return creerAVL(e);
    }
    else if (e->station < a->station->somme_conso){
        a->fg = insertionAVL(a->fg, e, h);
    }
    else{
        *h = 0;
        return a;
    }

    if (*h != 0){
        a->eq += *h;
        a = equilibreAVL(a);
        *h = (a->eq == 0) ? 0 : 1; 
    }
    return a;
}

int consommationTotal(AVL * a){
    if (a == NULL){
        return 0;
    }
    else {
        return a->station->somme_conso + consommationTotal(a->fg) + consommationTotal(a->fd);
    }
}