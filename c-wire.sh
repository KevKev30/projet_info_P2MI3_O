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
fichier_csv="$1"

#verifie si le fichier existe
if [[ ! -e $fichier_csv ]] ; then
    echo "erreur ce fichier n'existe pas"
    option_aide
    exit 1
fi

if [ $# -ne 3 ] && [ $# -ne 4 ]; then
    echo "Attention nombre d'arguments incorrect"
    echo " "
    option_aide
fi

#crée un fichier temporaire qui contiendra les données triées
fichier_tmp="tmp/tempo.csv"

#paramètres des valeurs de chaque argument
station=$2
consommateur=$3
centrale=-1

if [ $# -eq 4 ]; then
	centrale=$4
fi

if [ $# -eq 4 ] && { ! [[ "$centrale" =~ ^[0-9]+$ ]] || [ "$centrale" -lt 1 ] || [ "$centrale" -gt 5 ]; }; then
    echo "Attention numero de centrale incorrect"
    echo " "
    option_aide
fi

if [[ "$station" != "hvb" ]] && [[ "$station" != "hva" ]] && [[ "$station" != "lv" ]]; then
    echo "Attention station incorrecte"
    echo " "
    option_aide
fi

if [[ "$consommateur" != "comp" ]] && [[ "$consommateur" != "indiv" ]] && [[ "$consommateur" != "all" ]]; then
    echo "Attention consommateur incorrect"
    echo " "
    option_aide
fi

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
if [[ ! -e $input ]] ; then
    mkdir -p input
fi
if [[ ! -e $test ]] ; then
    mkdir -p test
fi
cp "$1" "input/entree.csv"

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

    case $station in
        hvb)
            if [ $# -eq 3 ]; then
                tail -n+2 "$fichier_csv" | cut -d';' -f2,3,4,7,8 | grep -E "^[0-9]+;-;-;" | cut -d ";" -f1,4,5 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
            else
                tail -n+2 "$fichier_csv" | cut -d';' -f1,2,3,4,7,8 | grep -E "^$centrale;[0-9]+;-;-;" | cut -d ";" -f2,5,6 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
            fi
        ;;
        hva)
            if [ $# -eq 3 ]; then
                tail -n+2 "$fichier_csv" | cut -d';' -f3,4,7,8 | grep -E "^[0-9]+;-;" | cut -d ";" -f1,3,4 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
            else
                tail -n+2 "$fichier_csv" | cut -d';' -f1,3,4,7,8 | grep -E "^$centrale;[0-9]+;-;" | cut -d ";" -f2,4,5 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
            fi         
        ;;
        lv)
        case $consommateur in
            comp)
                if [ $# -eq 3 ]; then
                    tail -n+2 "$fichier_csv" | cut -d';' -f4,6,7,8 | grep -E "^[0-9]+;-;" | cut -d ";" -f1,3,4 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
                else
                    tail -n+2 "$fichier_csv" | cut -d';' -f1,4,6,7,8 | grep -E "^$centrale;[0-9]+;-;" | cut -d ";" -f2,4,5 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
                fi
            ;;
            indiv)
                if [ $# -eq 3 ]; then
                    tail -n+2 "$fichier_csv" | cut -d';' -f4,5,7,8 | grep -E "^[0-9]+;-;" | cut -d ";" -f1,3,4 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
                else
                    tail -n+2 "$fichier_csv" | cut -d';' -f1,4,5,7,8 | grep -E "^$centrale;[0-9]+;-;" | cut -d ";" -f2,4,5 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
                fi
            ;;
            all)
                if [ $# -eq 3 ]; then
                    tail -n+2 "$fichier_csv" | cut -d';' -f4,7,8 | grep -E "^[0-9]+;" | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
                else
                    tail -n+2 "$fichier_csv" | cut -d';' -f1,4,7,8 | grep -E "^$centrale;[0-9]+;" | cut -d';' -f2,3,4 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
                fi
            ;;
        esac
    esac



cd codeC
chmod 777 "main"
./main "../$fichier_tmp" > "../tmp/fichier_triée.csv"
if [ $# -eq 3 ]; then
    name="test/${station}_${consommateur}.csv"
else
    name="test/${station}_${consommateur}_${centrale}.csv"
fi
echo "Identifiant station:Capacite:Consommation" > "../$name"
sort "../tmp/fichier_triée.csv" -t':' -n -k2 >> "../$name"
cd ..

if [[ "$consommateur" == "all" ]]; then
    tail -n+2 "$name" | sort -t':' -n -k3 > "tmp/fichier_triée2.csv"
    tail -n10 "tmp/fichier_triée2.csv" > "tmp/fichier_triée3.csv"
    head -n10 "tmp/fichier_triée2.csv" >> "tmp/fichier_triée3.csv"
    if [ $# -eq 3 ]; then
        filename="test/lv_all_minmax.csv"
    else
        filename="test/lv_all_minmax_$4.csv"
    fi
    echo "Identifiant station:Capacite:Consommation:Rendement" > "$filename"
    awk -F: '{$4=$2-$3} {print $0}' OFS=: "tmp/fichier_triée3.csv" | sort -t':' -n -k4 >> "$filename"
fi

#récupère le temps à la fin du traitement
fin=$(date +%s)
duree=$(( $fin - $debut))
echo "Le traitement a durée $duree s"