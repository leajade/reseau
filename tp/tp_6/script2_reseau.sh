#!/bin/bash

# $1 paramètre 1 : Lock or Shutdown
# $2 paramètre 2 : Time

if [ $# = 2 ]
then
    if [ $1 = "lock" ]
    then 
            echo "L'écran va se locker dans $2 secondes."
            sleep $2
            pmset displaysleepnow # lock
    elif [ $1 = "shutdown" ]
    then
            echo "L'ordinateur va s'éteindre dans $2 secondes."
            sleep $2
            sudo shutdown # shutdown
    else 
            echo "Les arguments passés sont incorrects."
    fi
else 
        echo "Le nombres d'arguments doient être de 2."
fi