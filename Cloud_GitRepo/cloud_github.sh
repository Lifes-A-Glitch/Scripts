#!/bin/bash

################
# Uncomment if you want the script to always use the scripts
# directory as the folder to look through
#REPOSITORIES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sync() 
{
  cd "/home/pi/USB/GithubRepo/repos"
  REPOSITORIES=$(pwd)
  IFS=$'\n'
  for REPO in $(ls "$REPOSITORIES"); do
    if [ -d "$REPOSITORIES/$REPO" ]; then
      echo "-------------------------------------------------------------"
      printf "\nUpdating $REPOSITORIES/$REPO at $(date +"%b-%d-%Y %r")\n"
      if [ -d "$REPOSITORIES/$REPO/.git" ]; then
        cd "$REPOSITORIES/$REPO"
        printf "\nGetting repository status...\n"
        git status
        printf "\nFetching"
        git fetch
        printf "\nPulling\n"
        git pull --verbose
      else
        printf "\nSkipping because it doesn't look like it has a .git folder.\n"
      fi
      printf "\nDone at $(date +"%b-%d-%Y_%r")\n"
      echo "-------------------------------------------------------------"
    fi
    cd "/home/pi/USB/GithubRepo/repos"
  done
}

sync >> /home/pi/USB/GithubRepo/logs/"$(date +"%b-%d-%Y_%H:%M:%S")".txt