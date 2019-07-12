#!/bin/bash
# Script for cleaning up the chrooted environment

WORKING_PATH="./workspace"
PACKAGE_PATH="/root"
TEMP_PATH="./temp"

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

cEcho "[+] Unmounting chrooted system"
umount -lf $WORKING_PATH/proc
umount -lf $WORKING_PATH/sys
umount -lf $WORKING_PATH/dev

cEcho "[+] Cleaning chrooted environment"
cp -rf $WORKING_PATH$PACKAGE_PATH/filesystem.manifest $TEMP_PATH/filesystem.manifest
rm -rf $WORKING_PATH$PACKAGE_PATH/chrooted.sh
rm -rf $WORKING_PATH$PACKAGE_PATH/filesystem.manifest
rm -rf $WORKING_PATH/run/systemd/*


cEcho "[+] Chrooted environment cleaning Completed"
