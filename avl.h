typedef struct station{
    int identifiant;
    int capacite;
    int somme_conso;
}station;


typedef struct AVL{
    station st;
    int eq;
    struct * AVL fd;
    struct * AVL fg;
}AVL;

int estVide(AVL * a);
int max(int a, int b);
int min(int a, int b);
int max3(int a, int b, int c);
int min3(int a, int b, int c);
AVL * creerAVL(station e);
