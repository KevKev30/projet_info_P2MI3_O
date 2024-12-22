# projet_info_P2MI3_O

Projet d'informatique pour la fin du premier semestre en Pré-ing 2
Sujet : C-wire

## Contributeurs

    - NGUYEN OANH Kévin
    - JOACHIM Anaëlle
    - EDOUARD Axel

## Utilisation 

Pour pouvoir lancer le programme, il faudra taper la commande suivante :
    bash c-wire.sh nom_fichier_à_traiter type_station type_consommateur (identifiant_centrale)

Exemple : - lorsqu'on veut traiter la station "hva" avec le consommateur "comp" sur le fichier donnée par les enseignants (c-wire_v25.dat), on tapera ceci dans le terminal :
                bash c-wire.sh c-wire_v25.dat hva comp
          - si on veut ajouter l'identifiant d'une station (par exemple 4), on tapera ceci dans le terminal :
                bash c-wire.sh c-wire_v25.dat hva comp 4

## Description du projet

Le dossier du projet doit être composé de plusieurs parties :
    - Un dossier codeC où les fichiers .h, .c et le makefile sont stockés.
    - Un dossier input qui permet de stocker un fichier .csv qui copie le contenu du fichier d'entrée.
    - Un dossier test qui stocke le fichier .csv final.
    - Un dossier tmp qui stocke les fichiers intermédiaires.
    - Le fichier d'entrée.
    - Le script Shell qui fait le filtrage des données en fonction des demandes de l'utilisateur grâce aux fichiers intermédiaires et au programme C.

