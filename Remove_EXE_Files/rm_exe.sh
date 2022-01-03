#!/bin/bash
##############################
# This is a script to recursively 
# go through all files and delete .gitignores
##############################

read -p "Removing executables from Low Level Programming";

find . -type f -name "*.exe" -exec rm -rf {} \;

read -p "Removal process complete...";