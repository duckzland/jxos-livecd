#!/bin/bash
# Script for generating packed squashfs

SOURCE_PATH="./source"
DATA_PATH="./data"
WORKING_PATH="./workspace"
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


cEcho "[+] Unmounting chrooted environment first"
umount -lf $WORKING_PATH/proc
umount -lf $WORKING_PATH/sys
umount -lf $WORKING_PATH/dev


cEcho "[+] Preparing folders"
mkdir -p $SOURCE_PATH/{casper,isolinux,install}



cEcho "[+] Preparing environment"
cp -Lf $WORKING_PATH/vmlinuz $SOURCE_PATH/casper/vmlinuz
cp -Lf $WORKING_PATH/initrd.img $SOURCE_PATH/casper/initrd
cp -f /usr/lib/ISOLINUX/isolinux.bin $SOURCE_PATH/isolinux/
cp -f /usr/lib/syslinux/modules/bios/ldlinux.c32 $SOURCE_PATH/isolinux/
cp -f /boot/memtest86+.bin $SOURCE_PATH/install/memtest
cp -rf $DATA_PATH/isolinux $SOURCE_PATH/
cp -f $DATA_PATH/README.diskdefines $SOURCE_PATH/

cEcho "[+] Building manifest"
cp -f $TEMP_PATH/filesystem.manifest $SOURCE_PATH/casper/filesystem.manifest
cp -f $SOURCE_PATH/casper/filesystem.manifest $SOURCE_PATH/casper/filesystem.manifest-desktop

REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
for i in $REMOVE
do
        sudo sed -i "/${i}/d" $SOURCE_PATH/casper/filesystem.manifest
done

cp -f $SOURCE_PATH/casper/filesystem.manifest $SOURCE_PATH/casper/filesystem.manifest-desktop


cEcho "[+] Removing old squash fs"
rm -f $SOURCE_PATH/casper/filesystem.squashfs


cEcho "[+] Building squashfs"
# Exclude boot to save space if no installation needed
mksquashfs $WORKING_PATH $SOURCE_PATH/casper/filesystem.squashfs -e boot -b 1048576 -comp xz -Xdict-size 100%
#mksquashfs $WORKING_PATH $SOURCE_PATH/casper/filesystem.squashfs -e boot
#mksquashfs $WORKING_PATH $SOURCE_PATH/casper/filesystem.squashfs


cEcho "[+] Updating filesystem size"
printf $(du -sx --block-size=1 $WORKING_PATH | cut -f1) > $SOURCE_PATH/casper/filesystem.size

cEcho "[+] Regenerating md5sum"
rm -f $SOURCE_PATH/md5sum.txt
find $WORKING_PATH/ -type f -print0 | sudo xargs -0 md5sum | grep -v "\./md5sum.txt" | > $SOURCE_PATH/md5sum.txt

cEcho "[+] Complete"


