#include "avl.h"

int main(int argc, char * argv[]){
    AVL * a;
    Station e;
    int * h;
    FILE * fichier = fopen("tmp.csv", "r");
    if (fichier == NULL){
        exit(1);
    }
    if (argc != 1){
        exit(2);
    }
    while (scanf("%d:%d:%d", &e.identifiant, &e.capacite, &e.somme_conso) == 3){
        a = recherche(a, e, &h);
    }
    afficherStation(a);
    libererAVL(a);
    fclose(fichier);
    return 0;
}