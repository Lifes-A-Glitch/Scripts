#!/bin/bash

if [ $# -lt 1 ]
then
        echo "Usage: ./create_project.sh <project_name>";
else
        PRJ_NAME="$1.git"
        HOSTIP="$( hostname -I | cut -f1 -d' ')"
        COMMAND="git remote add pi pi@$HOSTIP:$HOME/usbdrv/$PRJ_NAME"
        mkdir $HOME/usbdrv/$PRJ_NAME || echo "Project Already Exists..."
        cd $HOME/usbdrv/$PRJ_NAME
        git init --bare && echo "Use this command to add origin $COMMAND"
fi
