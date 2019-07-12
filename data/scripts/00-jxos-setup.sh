#!/bin/bash

PATH="/home/jxminer/setup"
FILE_PATH="/home/jxminer/files"
NVIDIA=`/bin/dmesg | /bin/grep "No NVIDIA graphics adapter found!" | /usr/bin/wc -l`

# HELPER FUNCTION
function cEcho(){
    local exp=$1;
    local color="green";
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | /usr/bin/tr '[:upper:]' '[:lower:]') in
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
    /usr/bin/tput setaf $color;
    echo $exp;
    /usr/bin/tput sgr0;
}

# Retrieving IP via dhclient
cEcho "[+] Retrieving dynamic ip via dhclient"
/sbin/dhclient


# Already configured bailing out
if [ -f $PATH/.setup-completed ];
then
    cEcho "[+] Already completed setup previously, remove $PATH/.setup-completed file to re-setup again."
    exit 0
fi


# Setting up NVIDIA
# Bugs in Ubuntu 18 can cause infinite udev loop of death if we install nvidia related services when the machine
# has no nvidia adapter on it
if [ $NVIDIA -gt 0 ];
then
    cEcho "[+] No NVIDIA graphics adapter found"
else
    if [ ! -f /lib/systemd/system/nvidia-persistenced.service ];
    then
        cEcho "[+] Setting up NVIDIA adapter"
        cEcho "[-] Enabling NVIDIA persistenced"
        /bin/cp $FILE_PATH/71-nvidia.rules /lib/udev/rules.d/71-nvidia.rules
        /bin/cp $FILE_PATH/files/nvidia-persistenced.service /lib/systemd/system/nvidia-persistenced.service
        /bin/systemctl daemon-reload
        /bin/systemctl enable nvidia-persistenced

        cEcho "[-] Generating Xorg settings for nvidia-settings"
        /usr/bin/nvidia-xconfig -a --allow-empty-initial-configuration --use-display-device="DFP-0:/etc/X11/edid.bin" --$

        cEcho "[-] Restarting udev"
        /bin/systemctl restart udev

    fi
fi

# Setting up AMD
cEcho "[+] Setting up AMD adapter"
echo "export LLVM_BIN=/opt/amdgpu-pro/bin" || tee /etc/profile.d/amdgpu-pro.sh


# Trying to detect the machine temperature and fan sensors
cEcho "[+] Setting up Sensors"
(while :; do echo ""; done) | /usr/sbin/sensors-detect

# Mark that the setup completed
cEcho "[+] Setup complete"
echo " " > $PATH/.setup-completed

exit 0
