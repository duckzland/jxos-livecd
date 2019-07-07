#!/bin/bash

MOUNT_PATH="./cdrom"
SOURCE_PATH="./source"
DATA_PATH="./data"
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

cEcho "[+] Unmounting chrooted workspace"
umount -lf $WORKING_PATH/proc
umount -lf $WORKING_PATH/sys
umount -lf $WORKING_PATH/dev

cEcho "[+] Removing workspace"
rm -rf $WORKING_PATH/*

cEcho "[+] Removing temp folder"
rm -rf $TEMP_PATH/*

cEcho "[+] Unmounting cdrom"
umount $MOUNT_PATH

cEcho "[+] Cleaning isofile content"
rm -rf $SOURCE_PATH/*
rm -rf $SOURCE_PATH/.disk*
echo ""



