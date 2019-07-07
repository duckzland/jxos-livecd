#!/bin/bash

ARCH="amd64"
RELEASE="bionic"
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

cEcho "[+] Bootstraping"
debootstrap --arch=$ARCH $RELEASE $WORKING_PATH
cp $DATA_PATH/sources.list $WORKING_PATH/etc/sources.list


cEcho "[+] Complete"
