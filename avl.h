typedef struct Station{
    int identifiant;
    int capacite;
    int somme_conso;
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
int consommationTotal(AVL * a);
void ajoutConso(AVL *a, Station e);
