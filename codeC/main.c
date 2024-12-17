#include "avl.h"

int main(int argc, char * argv[]){
    AVL * a;
    Station e;
    int * h;
    FILE * fichier = fopen("tmp.csv", "r");
    while (scanf("%d:%d:%d", e.identifiant, e.capacite, e.somme_conso) == 3){
        a = recherche(a, e, &h);
    }
    afficherStation(a);
    freeAVL(a);
    return 0;
}