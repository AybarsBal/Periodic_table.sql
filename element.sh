#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"



if [[ -z $1 ]]
then
  # if there is no $1
  echo Please provide an element as an argument.

else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi

  #if element not exits
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."

  else
  #if element exist
     NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
     SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
     SELECTED_ROW=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
     

     echo "$SELECTED_ROW" | while IFS="|" read -r atomic_number atomic_mass melt boil type_id
     do
       type=$($PSQL "SELECT type FROM types WHERE type_id = $type_id")
       echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $type, with a mass of $atomic_mass amu. $NAME has a melting point of $melt celsius and a boiling point of $boil celsius."
     done

  fi


  

  

fi
