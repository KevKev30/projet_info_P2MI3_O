#!/bin/bash

#paramètre du chemin du fichier csv
fichier_csv=$1
#verifie si le fichier existe
if [[ ! -e $fichier_csv ]] ; then
    echo "erreur ce fichier n'existe pas"
    exit 1
fi

nom_script=$0 
echo "nom du script : $nom_script"
echo "Contenu du fichier CSV :"
#cat "$fichier_csv"


#paramètres des valeurs de chaque argument
type_station=$2
type_consommateur=$3
id_central=$4
option_aide=$5



#fonction qui demande à l'itulisateur de choisir le type de station qu'il veut étudier
function choix_station(){
    echo "Voici les differentes station :"
    echo " hvb"
    echo " hva"
    echo " lv"
    read -p "Quel station souhaitez-vous analyser ? " station
    case $station in 
        hvb) echo "Vous avez choisi la station : $station (high-voltage B)" ;;
        hva) echo "Vous avez choisi la station : $station (high-voltage A)";;
        lv) echo "Vous avez choisi la station : $station (low-voltage)";;
        *) echo "La station $station n'existe pas, veuillez réessayez"; choix_station ;;
    esac
}
choix_station


#fonction qui demande à l'utilisateur de choisir le consommateur qu'il veut étudier
function choix_consommateur(){
    echo "Voici les differents consommateur :"
    echo " comp"
    echo " indiv"
    echo " all"
    read -p "Quel consommateur souhaitez-vous analyser ? " consommateur
    case $consommateur in 
        comp) echo "Vous avez choisi le consommateur : $consommateur (entreprises)";;
        indiv) echo "Vous avez choisi le consommateur : $consommateur (particuliers)";;
        all) echo "Vous avez choisi le consommateur : $consommateur (tous)";;
        *) echo "Le consommateur $consommateur n'existe pas, veuillez réessayez"; choix_consommateur ;;
    esac
    
}
choix_consommateur


#verification options interdites
if { [[ "$station" == "hvb" ]] || [[ "$station" == "hva" ]]; } && { [[ "$consommateur" == "indiv" ]] || [[ "$consommateur" == "all" ]]; }; then
    echo "Attention cette option est interdites"
    choix_station
    choix_consommateur
    
fi


if [[ ! -e $graphs ]] ; then
    mkdir -p graphs
fi

#probleme au moment de vider tmp
if [[ ! -e $tmp ]] ; then
    mkdir -p tmp
else 
    rm -r tmp
fi 



#Vérifier la présence de l'exécutable C et lancer la compilation 





#récupère le temps au debut du traitement 
debut=$(date +%s)



#traitement de données




#récupère le temps à la fin du traitement
fin=$(date +%s)


duree=$(( $fin - $debut))
echo "Le traitement a durée $duree s"