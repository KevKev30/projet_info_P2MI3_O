#!/bin/bash

nom_script=$0 
echo "nom du script : $nom_script"

#paramètre du chemin du fichier csv
fichier_csv=$1
echo "Contenu du fichier CSV :"
cat "$fichier_csv"


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
        hvb) echo "Vous avez choisi la station : $station" ;;
        hva) echo "Vous avez choisi la station : $station";;
        lv) echo "Vous avez choisi la station : $station";;
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
        comp) echo "Vous avez choisi le consommateur : $consommateur";;
        indiv) echo "Vous avez choisi le consommateur : $consommateur";;
        all) echo "Vous avez choisi le consommateur : $consommateur";;
        *) echo "Le consommateur $consommateur n'existe pas, veuillez réessayez"; choix_consommateur ;;
    esac
    
}
choix_consommateur




#verification options interdites
if { [[ "$station" == "hvb" ]] || [[ "$station" == "hva" ]]; } && { [[ "$consommateur" == "indiv" ]] || [[ "$consommateur" == "all" ]]; }; then
    echo "Attention cette option est interdites"
    exit 1
fi




