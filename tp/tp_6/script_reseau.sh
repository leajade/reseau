#!/bin/bash


printf "%b\n" "Le nom de la machine, l'OS et sa version ainsi que la date et l'heure d'allumage de la machine : \n" 
system_profiler SPSoftwareDataType | grep "Computer Name:" # Nom machine 
system_profiler SPSoftwareDataType | grep -A 1 "System Version:" # OS et version
system_profiler SPSoftwareDataType | grep -A 1 "Time since boot:" # date et heure d'allumage

echo -n "L'IP principale de cette machine est " 
ipconfig getifaddr en0  # IP principale

printf "%b\n" "\nL'OS est-il à jour ?"
softwareupdate -l  # Os à jour ?

printf "%b\n" "\nL'espace Ram utilisé en pourcentage ainsi que l'espace disque utilisé et disponible : "
top -l 1 | grep -E "^CPU|^Phys" # Espace Ram utilisée/Espace disq dispo

printf "%b\n" "\nListe des utilisateurs de cette machine :"
dscl . list /Users | grep -v '_' # Liste des users

printf "%b\n" "\nLe temps de réponse moyen d'un ping 8.8.8.8 en ms:"
ping -c 4 8.8.8.8 | tail -1| awk '{print $4}' | cut -d '/' -f 2 # temps de réponse moyen ping 8.8.8.8

printf "%b\n" "\nDébit de download et d'upload de la machine :"
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python - # Debit max download & upload vers internet