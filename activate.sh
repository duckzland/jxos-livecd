#!/bin/bash
# Activate the chrooted environment with networking and devices

WORKING_PATH="./workspace"

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

cEcho "[+] Preparing chroot"
rsync -avh --devices --specials /run/systemd/resolve $WORKING_PATH/run/systemd
mount --bind /dev/ $WORKING_PATH/dev

cEcho "[+] Chroot is ready"
