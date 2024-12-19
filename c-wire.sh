#!/bin/bash

function option_aide(){
    echo "Voici une aide détaillée sur l'utilisation du script"
    echo " "
    echo "  Options :"
    echo " "
    echo "      -Chemin du fichier       (Obligatoire) ->  indique l'endroit où se trouve le fichier d'entrée ."
    echo "      -type de station         (Obligatoire) ->  valeurs possibles : hvb, hva, lv."
    echo "      -type de consommateur    (Obligatoire) ->  valeurs possibles : comp, indiv, all."
    echo "      -identifiant de centrale (Optionnel)   ->  filtre les résultats pour une centrale spécifique."
    echo "      -Option d'aide (-h)      (Optionnel)   ->  Affiche une aide et ignore toutes les autres options."
    echo " "
    echo "  Options interdites :"
    echo " "
    echo "      hvb all, hvb indiv, hva all, hvb indiv" 
    echo " "
    echo "  Fonctionnalités :"
    echo " "
    echo "      -Assurer la coherence des options "
    echo "      -Vérifier la présence de l'exécutable et lancer la compilation"
    echo "      -Vérifier la présence du dossier tmp et graphs, et les créer si ils n'éxistent pas "
    echo "      -Afficher la durée de chaque traitement"
    echo " "
    echo "  But Final :"
    echo " "
    echo "      Créer un fichier avec la valeur de capacité et la somme des consommateurs branchés à ces stations"
    exit 0
}

#cérification de la présence de l'option d'aide (-h) (Ne fonctionne pas encore)
if [[ "$@" =~ "-h" ]]; then
    option_aide
fi

#paramètre du chemin du fichier csv
fichier_csv=$1


#verifie si le fichier existe
if [[ ! -e $fichier_csv ]] ; then
    echo "erreur ce fichier n'existe pas"
    option_aide
    exit 1
fi

nom_script=$0 
echo "nom du script : $nom_script"
echo "Contenu du fichier CSV :"
cat "$fichier_csv"


#paramètres des valeurs de chaque argument
type_station=$2
type_consommateur=$3
id_central=$4


#fonction qui demande à l'itulisateur de choisir le type de station qu'il veut étudier
function choix_station(){
    echo "Voici les differentes stations :"
    echo " hvb"
    echo " hva"
    echo " lv"
    read -p "Quel station souhaitez-vous analyser ? " station
    case $station in 
        hvb) echo "Vous avez choisi la station : $station (high-voltage B)" ;;
        hva) echo "Vous avez choisi la station : $station (high-voltage A)";;
        lv) echo "Vous avez choisi la station : $station (low-voltage)";;
        *) echo "La station $station n'existe pas, veuillez réessayez"; 
        choix_station 
    esac
}
choix_station


#fonction qui demande à l'utilisateur de choisir le consommateur qu'il veut étudier
function choix_consommateur(){
    echo "Voici les differents consommateurs :"
    echo " comp"
    echo " indiv"
    echo " all"
    read -p "Quel consommateur souhaitez-vous analyser ? " consommateur
    case $consommateur in 
        comp) echo "Vous avez choisi le consommateur : $consommateur (entreprises)";;
        indiv) echo "Vous avez choisi le consommateur : $consommateur (particuliers)";;
        all) echo "Vous avez choisi le consommateur : $consommateur (tous)";;
        *) echo "Le consommateur $consommateur n'existe pas, veuillez réessayez"; 
        choix_consommateur ;;
    esac
    
}
choix_consommateur


#verification options interdites
if { [[ "$station" == "hvb" ]] || [[ "$station" == "hva" ]]; } && { [[ "$consommateur" == "indiv" ]] || [[ "$consommateur" == "all" ]]; }; then
    echo "Attention cette option est interdites"
    echo " "
    option_aide
    choix_station
    choix_consommateur
    
fi


if [[ ! -e $graphs ]] ; then
    mkdir -p graphs
fi

if [[ ! -e $tmp ]] ; then
    mkdir -p tmp
fi

if [ -e $tmp ] ; then
    for i in tmp/* ; do
        if [ -e $i ]; then
            echo "{$i} va etre supprimé"
            rm $i
        fi
    done 
fi 



#Vérifier la présence de l'exécutable C et lancer la compilation 


cd codeC
make
executable=main
if [[ ! -x $executable ]] ; then
    echo "Lancement de la compilation"
    gcc $executable -o main.c 
    if [ $? != 0] ; then
        echo "Erreur la compilation à échouée"
        exit 2
    fi
fi
cd ..



#récupère le temps au debut du traitement 
debut=$(date +%s)



#traitement de données
sleep 1



#récupère le temps à la fin du traitement
fin=$(date +%s)
duree=$(( $fin - $debut))
echo "Le traitement a durée $duree s"