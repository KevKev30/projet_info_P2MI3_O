#include "avl.h"

//Le main va ouvrir le fichier à traiter et va le "retrier" en fonction des identifiants des stations via un AVL. Lorsqu'il trouve deux stations avec des identifiants identiques,
//Celui-ci additionne leur consommation.
//A la fin, le main écrit le résultat sur le fichier et libère l'AVL.

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
            recherche(a, e);
        }
    }
    afficherStation(a);
    libererAVL(a);
    fclose(fichier);
    return 0;
}