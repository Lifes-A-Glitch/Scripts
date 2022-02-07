#!/bin/bash

################
# Uncomment if you want the script to always use the scripts
# directory as the folder to look through
#REPOSITORIES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# function to cd into repos folder.
cd_repo_folder() {
	cd "/home/test/Testing/test"
	printf "In Directory $(pwd)"
}

# main function of the script
sync() {
	if [ -e "active_repo_list.txt" ]; then
		file="./active_repo_list.txt"
		REPOSITORIES=$(pwd)
		IFS=$'\n'
		# cd_repo_folder

		for line in $(cat active_repo_list.txt); do
		{
			if [ -d "$REPOSITORIES/$REPO" ]; then
				echo "-------------------------------------------------------------"
				printf "\nUpdating $REPOSITORIES/$line at $(date +"%b-%d-%Y %r")\n"
				if [ -d "$REPOSITORIES/$line/.git" ]; then
					cd "$REPOSITORIES/$line"
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
		}
		done
	else
		printf "\nA file named \'active_repo_list.txt\' must be created and also have active repo folder names in the list itself...\n"
	fi
	exit
}

sync 
#>> /home/pi/USB/GithubRepo/logs/"$(date +"%b-%d-%Y_%H:%M:%S")".txt
