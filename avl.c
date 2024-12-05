#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "avl.h"


int estVide(AVL * a){
    return a == NULL;
}


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


AVL * creerAVL(station e){
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


AVL * suppressionMinAVL(AVL * a, int * h, station * pe){
    AVL * tmp;
    if(a->fg == NULL){
        pe->station->identifiant = a->station->identifiant;
        pe->station->capacite = a->station->capacite;
        pe->station->somme_conso = a->station->somme_conso;
        pe->eq = a->eq;
        pe->fd = a->fd;
        pe->fg = a->fg;
        *h = -1;
        tmp = a;
        a = a->fd;
        free(tmp);
        return a;
    }
    else{
        a->fg = suppMinAVL(a->fg, h, pe);
        *h = -*h;
    }
    if(*h != 0){
        a->eq += *h;
        a = equilibreAVL(a);
        if(a->eq == 0){
            *h = -1;
        }
        else{
            *h = 0;
        }
    }
    return a;
}
