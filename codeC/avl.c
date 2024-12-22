#include "avl.h"

//Cette fonction compare 2 entiers et retourne le plus grand.
int max(int a, int b){
    if (a<b){
        return b;
    }
    return a;
}

//Cette fonction compare 2 entiers et retourne le plus petit.
int min(int a, int b){
    if (a>b){
        return b;
    }
    return a;
}

//Cette fonction compare 3 entiers et retourne le plus grand.
int max3(int a, int b, int c){
    return max(max(a, b), c);
}

//Cette fonction compare 3 entiers et retourne le plus petit.
int min3(int a, int b, int c){
    return min(min(a, b), c);
}

//Cette fonction crée un noeud qui contient une station.
AVL * creerAVL(Station e){
    AVL * a = malloc(sizeof(AVL));
    if (a==NULL){
        exit(0);
    }
    a->station.identifiant = e.identifiant;
    a->station.capacite = e.capacite;
    a->station.somme_conso = e.somme_conso;
    a->equilibre = 0;
    a->fg = NULL;
    a->fd = NULL;
    return a;
}

//Cette fonction fait une rotation gauche sur un AVL.
AVL * rotationGauche(AVL * a){
    AVL * pivot = a->fd;
    int eqa, eqp;

    a->fd = pivot->fg;
    pivot->fg = a;

    eqa = a->equilibre;
    eqp = pivot->equilibre;

    a->equilibre = eqa - max(eqp, 0) - 1;
    pivot->equilibre = min3(eqa-2, eqp+eqa-2, eqp-1);

    return pivot;
}

//Cette fonction fait une rotation droite sur un AVL.
AVL * rotationDroite(AVL * a){
    AVL * pivot = a->fg;
    int eqa, eqp;

    a->fg = pivot->fd;
    pivot->fd = a;

    eqa = a->equilibre;
    eqp = pivot->equilibre;

    a->equilibre = eqa - min(eqp, 0) + 1;
    pivot->equilibre = max3(eqa+2, eqp+eqa+2, eqp+1);

    return pivot;
}

//Cette fonction fait une double rotation gauche sur un AVL.
AVL * doubleRotationGauche(AVL * a){
    a->fd = rotationDroite(a->fd);
    return rotationGauche(a);
}

//Cette fonction fait une double rotation droite sur un AVL.
AVL * doubleRotationDroite(AVL * a){
    a->fg = rotationGauche(a->fg);
    return rotationDroite(a);
}

//Cette fonction rééquilibre un AVL si besoin. Sinon il retourne l'AVL.
AVL * equilibreAVL(AVL * a){
    if(a->equilibre <= -2){
        if(a->fg->equilibre <= 0){
            return rotationDroite(a);
        }
        else{
            return doubleRotationDroite(a);
        }
    }
    else if(a->equilibre >= 2){
        if(a->fd->equilibre >= 0){
            return rotationGauche(a);
        }
        else{
            return doubleRotationGauche(a);
        }
    }
    return a;
}

//Cette fonction insert une station dans un AVL et rééquilibre l'AVL si besoin.
AVL * insertionAVL(AVL * a, Station e, int *h){
    if (a == NULL){
        *h = 1;
        return creerAVL(e);
    }
    else if (e.identifiant < a->station.identifiant){
        a->fg = insertionAVL(a->fg, e, h);
        *h = -*h;
    }
    else if(e.identifiant > a->station.identifiant){
        a->fd = insertionAVL(a->fd, e, h);
    }
    else{
        *h = 0;
        return a;
    }

    if (*h != 0){
        a->equilibre += *h;
        a = equilibreAVL(a);
        *h = (a->equilibre == 0) ? 0 : 1;
    }
    return a;
}


//Cette fonction libère un AVL.
void libererAVL(AVL * a){
    if (a != NULL){
    libererAVL(a->fg);
    libererAVL(a->fd);
    free(a);
    }
}

//Cette fonction ajoute la consommation d'une station à une autre station.
void ajout_conso(AVL * a, Station e){
    if (a != NULL){
        a->station.somme_conso += e.somme_conso;
    }
}

//Cette fonction recherche si la station passée en paramètre existe dans l'AVL. Si oui, il additionne la consommation de cette station avec une station qui existe dans l'AVL et qu'il possède le même identifiant qu'elle. Sinon la fonction crée un neoud qui contient la station passée en paramètre.
void recherche(AVL * a, Station e, int *h){
    if (a == NULL){
        return ;
    }
    if (a->station.identifiant > e.identifiant){
        recherche(a->fg, e, h);
    }
    if (a->station.identifiant < e.identifiant){
        recherche(a->fd, e, h);
    }
    else{
        ajout_conso(a, e);
    }
}

//Cette fonction affiche le contenu de l'AVL passé en paramètre.
void afficherStation(AVL * a){
    if(a != NULL){
        afficherStation(a->fg);
        printf("%d:%ld:%ld \n", a->station.identifiant, a->station.capacite, a->station.somme_conso);
        afficherStation(a->fd);
    }
}
