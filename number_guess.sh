#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t -c"

echo "Enter your username:"
read USERNAME

# search if username already exists
USERNAME_EXISTS_RESULT=$($PSQL "SELECT COUNT(*), MIN(number_of_tries) FROM usernames_games WHERE username='$USERNAME';")

#save results in variables 
echo $USERNAME_EXISTS_RESULT | while read GAMES_PLAYED BAR BEST_GAME
do
  # if not found
  if [[ $GAMES_PLAYED = 0 ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else # if found, get info games_played and best_game
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
done

RANDOM_NUMBER=$((1 + $RANDOM % 1000))
echo $RANDOM_NUMBER

echo -e "\nGuess the secret number between 1 and 1000:"

USER_NUMBER_GUESS=0;
NUMBER_OF_TRIES=0;
while [ ! $USER_NUMBER_GUESS = $RANDOM_NUMBER ] 
do
  read USER_NUMBER_GUESS
  NUMBER_OF_TRIES=$((NUMBER_OF_TRIES+1))
  if [[ $USER_NUMBER_GUESS =~ ^[0-9]+$ ]]
  then
    if [[ $USER_NUMBER_GUESS -gt $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    else if [[ $USER_NUMBER_GUESS -lt $RANDOM_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
      fi
    fi
  else 
    echo "That is not an integer, guess again:"
  fi
done

echo "You guessed it in $NUMBER_OF_TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"
# add the game data to database
GAME_INSERT_RESULT=$($PSQL "INSERT INTO usernames_games(username, number_of_tries) VALUES('$USERNAME', $NUMBER_OF_TRIES);")
