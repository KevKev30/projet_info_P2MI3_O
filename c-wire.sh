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





    
function choix_station(){
    echo "Voici les differentes station :"
    echo " hvb"
    echo " hva"
    echo " lv"
    read -p "Quel station souhaitez-vous analyser ? " station
    case $station in 
        1) type_station="hvb";;
        2) type_station="hva";;
        3) type_station="lv";;
        *) echo "La station station n'existe pas, veuillez réessayez"; choix_station ;;
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
        1) type_consommateur="comp";;
        2) type_consommateur="indiv";;
        3) type_consommateur="all";;
        *) echo "Le consommateur station n'existe pas, veuillez réessayez"; choix_consommateur ;;
    esac
    
}
choix_consommateur






#verification options interdites
if { [[ "$type_station" == "hvb" ]] || [[ "$type_station" == "hva" ]]; } && { [[ "$type_consommateur" == "indiv" ]] || [[ "$type_consommateur" =="all" ]]; }; then
    echo "erreur"
    exit 1
fi






#fonction qui demande à l'itulisateur de choisir le type de station qu'il veut étudier
function choix_station(){
    echo "Voici les differentes station :"
    echo " hvb"
    echo " hva"
    echo " lv"
    read -p "Quel station souhaitez-vous analyser ? " station
    case $station in 
        hvb) echo "Vous avez choisi la station : $station" type_station="hvb";;
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
