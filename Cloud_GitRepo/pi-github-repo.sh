#!/bin/bash
as'pdlfkja'psdkljfa;lskdjf;laksjdf;laskj
################
# Uncomment if you want the script to always use the scripts
# directory as the folder to look through
#REPOSITORIES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# function to cd into repos folder.
cd_repo_folder() {
	cd "/home/pi/USB/GithubRepo/repos"
}

# main function of the script
sync() 
{
	if [ -e "./active_repo_list.txt" ]; then
		cd_repo_folder
		REPOSITORIES=$(pwd)
		IFS=$'\n'
		file="active_repo_list.txt"
		for REPO in $file; do
			if [ -d "$REPOSITORIES/$REPO" ]; then
				echo "-------------------------------------------------------------"
				printf "\nUpdating $REPOSITORIES/$REPO at $(date +"%b-%d-%Y %r")\n"
				if [ -d "$REPOSITORIES/$REPO/.git" ]; then
					cd "$REPOSITORIES/$REPO"
					echo "in here..."
					printf "In Directory $(pwd | cut -c 29)"
					# printf "\nGetting repository status...\n"
					# git status
					# printf "\nFetching"
					# git fetch
					# printf "\nPulling\n"
					# git pull --verbose
				else
					printf "\nSkipping because it doesn't look like it has a .git folder.\n"
				fi
				printf "\nDone at $(date +"%b-%d-%Y_%r")\n"
				echo "-------------------------------------------------------------"
			fi
			cd_repo_folder
		done
	else
		printf "\nA file named \'active_repo_list.txt\' must be created and also have active repo folder names in the list itself...\n"
	fi
	exit
}

sync # >>/home/pi/USB/GithubRepo/logs/"$(date +"%b-%d-%Y_%H:%M:%S")".txt