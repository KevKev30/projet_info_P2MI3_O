#!/bin/bash
#if [ $# -eq 0 ]; then
#    echo "usage : $0 /Documents/Pre-ing2/projet/projet_info_P2MI3_0/c-wire_v00.csv"
#    exit 1
#fi 
#fichier_csv="$1" 
#if [ ! -f "$fihier_csv" ]; then
#    echo "Erreur : le fichier $fichier_csv n'existe pas"
#    exit 2
#fi
#echo "Le fichier csv fourni est : $fichier_csv"
#echo "Contenu du fichier :"
#cat "$fichier_csv"


fichier_csv=/Documents/Pre-ing2/projet/projet_info_P2MI3_0/c-wire_v00.csv
echo "chemin du fichier : $fichier_csv"
cat "$fichier_csv"