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


#paramètre du chemin du fichier csv
fichier_csv=$1

#verifie si le fichier existe
if [[ ! -e $fichier_csv ]] ; then
    echo "erreur ce fichier n'existe pas"
    option_aide
    exit 1
fi

#crée un fichier temporaire qui contiendra les données triées
touch tmp.csv
fichier_tmp="tmp.csv"

echo "Contenu du fichier CSV :"
cat "$fichier_csv"


#paramètres des valeurs de chaque argument
station=$3
consommateur=$4


#fonction qui demande à l'utilisateur de choisir le type de station qu'il veut étudier
function choix_station(){
    echo "Voici les differentes stations :"
    echo " hvb"
    echo " hva"
    echo " lv"
    read -p "Quel station souhaitez-vous analyser ? " station
    echo "Si vous avez besoin d'aide, faites -h sur le terminal."
    case $station in 
        hvb) echo "Vous avez choisi la station : $station (high-voltage B)" ;;
        hva) echo "Vous avez choisi la station : $station (high-voltage A)";;
        lv) echo "Vous avez choisi la station : $station (low-voltage)";;
        -h)option_aide;;
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
    echo "Si vous avez besoin d'aide, faites -h sur le terminal."
    case $consommateur in 
        comp) echo "Vous avez choisi le consommateur : $consommateur (entreprises)";;
        indiv) echo "Vous avez choisi le consommateur : $consommateur (particuliers)";;
        all) echo "Vous avez choisi le consommateur : $consommateur (tous)";;
        -h)option_aide;;
        *) echo "Le consommateur $consommateur n'existe pas, veuillez réessayez";
        choix_consommateur
    esac
    
}
choix_consommateur


#verification options interdites
if { [[ "$station" == "hvb" ]] || [[ "$station" == "hva" ]]; } && { [[ "$consommateur" == "indiv" ]] || [[ "$consommateur" == "all" ]]; }; then
    echo "Attention cette option est interdite"
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
    make
    if [ $? != 0 ] ; then
        echo "Erreur la compilation à échouée"
        exit 2
    fi
fi
cd ..



#récupère le temps au debut du traitement 
debut=$(date +%s)



#traitement de données (Utilisation de chatGPT)
function filtrage(){
    case $station in
        hvb)
        while IFS=';', read -r c1 c2 c3 c4 c5 c6 c7 c8; do
            if [ "$c2" != "-" ] ; then
                  echo "$c2:$c7:$c8" >> "$fichier_tmp"
            fi
        done < "$fichier_csv"
        #cd codeC
        #chmod 777 "main.c"
        #./main.c "$fichier_tmp"
        ;;
        hva)
        while IFS=';', read -r c1 c2 c3 c4 c5 c6 c7 c8; do
            if [ "$c3" != "-" ] ; then
                  echo "$c3:$c7:$c8" >> "$fichier_tmp"
            fi
        done < "$fichier_csv"
        #./main.c "$fichier_tmp"
        ;;
        lv)
        case $consommateur in
            comp)
            while IFS=';', read -r c1 c2 c3 c4 c5 c6 c7 c8; do
                if [ "$c5" != "-" ] && [ "$c6" == "-" ] ; then
                  echo "$c4:$c7:$c8" >> "$fichier_tmp"
                fi
            done < "$fichier_csv"
            #./main.c "$fichier_tmp"
            ;;
            indiv)
            while IFS=';', read -r c1 c2 c3 c4 c5 c6 c7 c8; do
                if [ "$c5" == "-" ] && [ "$c6" != "-" ] ; then
                  echo "$c4:$c7:$c8" >> "$fichier_tmp"
                fi
            done < "$fichier_csv"
            #./main.c "$fichier_tmp"
            ;;
            all)
            while IFS=';', read -r c1 c2 c3 c4 c5 c6 c7 c8; do
                if [ "$c5" != "-" ] && [ "$c6" != "-" ] ; then
                  echo "$c4:$c7:$c8" >> "$fichier_tmp"
                fi
            done < "$fichier_csv"
            #./main.c "$fichier_tmp"
            ;;
        esac
    esac
}
filtrage
sleep 1



#récupère le temps à la fin du traitement
fin=$(date +%s)
duree=$(( $fin - $debut))
echo "Le traitement a durée $duree s"