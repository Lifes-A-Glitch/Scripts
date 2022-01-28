#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help() {
    # Display Help
    echo "Sends Wake On Lan packet if ping comes back with no connection
   
        Syntax: scriptTemplate [-p|a|m|V]
        Options:
            p       Designated for the port, defaulted to 9.
            a       Designated for the ip address
            m       Designated for the MAC address
            h       Print help (more information)
            v       Print software version and exit        
        "
}

# Main Program #

# Set variables
version="1.0"

while getopts "pamhv" option; do
    case ${option} in
    h) # display Help
        Help
        exit
        ;;
    v)  # display version
        echo "Software Version: $version"
        # echo "In the version option..."
        exit
        ;;
    \?) # Invalid option
        echo "Error: Invalid option"
        exit
        ;;
    esac
done
