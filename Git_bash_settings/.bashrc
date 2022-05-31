# This is a test to see what .bashrc actually does...

#Today function that spits out todays date
today() {
    echo "Date: $(date +"%A %d in %B of %Y (%r)")"
    return
}

# sync() {
#     ################
#     # Uncomment if you want the script to always use the scripts
#     # directory as the folder to look through
#     #REPOSITORIES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#     cd "E:\Code"
#     REPOSITORIES=$(pwd)
#     IFS=$'\n'
#     for REPO in $(ls "$REPOSITORIES"); do
#         if [ -d "$REPOSITORIES/$REPO" ]; then
#             echo "-------------------------------------------------------------"
#             printf "\nUpdating $REPOSITORIES/$REPO at $(date +"%b-%d-%Y %r")\n"
#             if [ -d "$REPOSITORIES/$REPO/.git" ]; then
#                 cd "$REPOSITORIES/$REPO"
#                 printf "\nGetting repository status...\n"
#                 git status
#                 printf "\nFetching"
#                 git fetch
#                 printf "\nPulling\n"
#                 git pull --verbose
#             else
#                 printf "\nSkipping because it doesn't look like it has a .git folder.\n"
#             fi
#             printf "\nDone at $(date +"%b-%d-%Y %r")\n"
#             echo "-------------------------------------------------------------"
#         fi
#         cd "E:\Code"
#     done
# }

sync()
{
    cd "E:\Code" && ./github.sh
}

###########################################################################
################################################
# Copied from Alias.sh
################################################
# Some good standards, which are not used if the user
# creates his/her own .bashrc/.bash_profile

# --show-control-chars: help showing Korean or accented characters
alias ls='ls -alhrt --color=auto --show-control-chars'
alias ll='ls -l'
alias class='cd "E:\Code"'
alias gs='git status --verbose'

case "$TERM" in
xterm*)
    # The following programs are known to require a Win32 Console
    # for interactive usage, therefore let's launch them through winpty
    # when run inside `mintty`.
    for name in node ipython php php5 psql python2.7; do
        case "$(type -p "$name".exe 2>/dev/null)" in
        '' | /usr/bin/*) continue ;;
        esac
        alias $name="winpty $name.exe"
    done
    ;;
esac
##########################################################################