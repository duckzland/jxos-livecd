#!/bin/bash
# Script for generating the chrooted environment

DATA_PATH="./data"
WORKING_PATH="./workspace"
WORKING_PACKAGE_PATH="./workspace/root"

function cEcho(){
    local exp=$1;
    local color="green";
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput setaf $color;
    echo $exp;
    tput sgr0;
}

# Calling activation script
./activate.sh

cEcho "[+] Copying files to chrooted environment"
cp -rf $DATA_PATH/{pip,deb,keys,files,chrooted.sh,scripts,jxminer} $WORKING_PACKAGE_PATH

cEcho "[+] Chrooting to workspace and populating them"
chroot $WORKING_PATH /root/chrooted.sh

# Calling deactivation script
./deactivate.sh

cEcho "[+] Completed"
