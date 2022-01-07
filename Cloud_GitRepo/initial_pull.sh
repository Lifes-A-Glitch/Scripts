#!/bin/bash
# Initial Pull of all github repos from a .txt file
initialpull() {
    # append gh-repo-list.txt file for more repos...
    input="/home/pi/USB/GithubRepo/scripts/gh-repo-list.txt"
    cd "/home/pi/USB/GithubRepo/repos"
    while IFS= read -r line; do
        git clone "$line"
    done <"$input"
}

initialpull >> /home/pi/USB/GithubRepo/logs/"InitialPullOfRepos_$(date +"%b-%d-%Y")".txt

# # TODO: for cloud-based services... add premade file structure making function.  
# remove script since its only needed for a massive pull.
# rm -f ./initial_pull.sh