#include "avl.h"

int main(int argc, char** argv){
    AVL * a = NULL;
    Station e = {0};
    int h;
    FILE * fichier = fopen(argv[1], "r");
    if (fichier == NULL){
        exit(1);
    }
    if (argc != 2){
        exit(2);
    }
    while (fscanf(fichier, "%d;%ld;%ld", &e.identifiant, &e.capacite, &e.somme_conso) != EOF){
        if (e.capacite != 0){
            a = insertionAVL(a, e, &h);
        }
        else{
            recherche(a, e, &h);
        }
    }
    afficherStation(a);
    libererAVL(a);
    fclose(fichier);
    return 0;
}