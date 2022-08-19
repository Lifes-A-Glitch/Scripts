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
    echo "--------------------------------------------------------------------"
    printf "Pushing $REPOSITORIES/$REPO at `date`\n"
    if [ -d "$REPOSITORIES/$REPO/.git" ]
    then
      cd "$REPOSITORIES/$REPO"
      echo "Everything should be commited before pushing..."
      printf "\nGit Pushed (Verbose)\n"
      git push --verbose
    else
      printf "\nSkipping because it doesn't look like it has a .git folder.\n"
    fi
    printf "\nDone at `date`\n"
    echo "--------------------------------------------------------------------"
  fi
done
