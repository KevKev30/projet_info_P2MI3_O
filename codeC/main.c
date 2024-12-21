#include "avl.h"

int main(int argc, char * argv[]){
    AVL * a = NULL;
    Station e;
    int h;
    FILE * fichier = fopen(argv[1], "r");
    if (fichier == NULL){
        exit(1);
    }
    if (argc != 1){
        exit(2);
    }
    while (fscanf(fichier, "%d:%d:%d", &e.identifiant, &e.capacite, &e.somme_conso) == 3){
        a = recherche(a, e, &h);
    }
    afficherStation(a);
    libererAVL(a);
    fclose(fichier);
    return 0;
}