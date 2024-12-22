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

#crée un fichier temporaire qui contiendra les données triées
fichier_tmp="tmp/tempo.csv"

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
        tail -n+2 "$fichier_csv" | cut -d';' -f2,3,4,7,8 | grep -E "^[0-9]+;-;-;" | cut -d ";" -f1,4,5 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
        ;;
        hva)
        tail -n+2 "$fichier_csv" | cut -d';' -f3,4,7,8 | grep -E "^[0-9]+;-;" | cut -d ";" -f1,3,4 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
        ;;
        lv)
        case $consommateur in
            comp)
            tail -n+2 "$fichier_csv" | cut -d';' -f4,6,7,8 | grep -E "^[0-9]+;-;" | cut -d ";" -f1,3,4 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
            ;;
            indiv)
            tail -n+2 "$fichier_csv" | cut -d';' -f4,5,7,8 | grep -E "^[0-9]+;-;" | cut -d ";" -f1,3,4 | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
            ;;
            all)
            tail -n+2 "$fichier_csv" | cut -d';' -f4,7,8 | grep -E "^[0-9]+;" | tr '-' '0' | sort -t';' -n -k3 > "$fichier_tmp"
            ;;
        esac
    esac
}
filtrage
sleep 1

cd codeC
chmod 777 "main"
./main "../$fichier_tmp" > "../tmp/fichier_triée.csv"
echo "Identifiant station:Capacite:Consommation" > "../test/${station}_${consommateur}.csv"
sort "../tmp/fichier_triée.csv" -t':' -n -k2 >> "../test/${station}_${consommateur}.csv"
cd ..
if [[ "$consommateur" == "all" ]]; then
    tail -n+2 "test/${station}_${consommateur}.csv" | 
fi

#récupère le temps à la fin du traitement
fin=$(date +%s)
duree=$(( $fin - $debut))
echo "Le traitement a durée $duree s"