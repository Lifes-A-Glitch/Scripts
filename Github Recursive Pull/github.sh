#!/bin/bash

################
# Uncomment if you want the script to always use the scripts
# directory as the folder to look through
#REPOSITORIES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPOSITORIES=`pwd`

IFS=$'\n'

for REPO in `ls "$REPOSITORIES"`
do
  if [ -d "$REPOSITORIES/$REPO" ]
  then
    printf "Updating $REPOSITORIES/$REPO at `date`"
    if [ -d "$REPOSITORIES/$REPO/.git" ]
    then
      cd "$REPOSITORIES/$REPO"
      printf "\nGetting repository status..."
      git status
      printf "\nFetching"
      git fetch
      printf "\nPulling\n"
      git pull
    else
      printf "\nSkipping because it doesn't look like it has a .git folder.\n"
    fi
    printf "\nDone at `date`"
    echo
  fi
done