#!/bin/bash
# Script for performing final JXOS setup

# When invoked at boot, we need to wait until nvidia is detected to avoid 
# loading nvidia services when no nvidia card found in the system
sleep 10

PATH="/home/jxminer/setup"
FILE_PATH="/home/jxminer/setup/files"
NVIDIA=`/bin/dmesg | /bin/grep "No NVIDIA graphics adapter found!" | /usr/bin/wc -l`

# Retrieving IP via dhclient
echo "[+] Retrieving dynamic ip via dhclient"
/sbin/dhclient


# Already configured bailing out
if [ -f $PATH/.setup-completed ];
then
    echo "[+] Already completed setup previously, remove $PATH/.setup-completed file to re-setup again."
    exit 0
fi


# Setting up NVIDIA
# Bugs in Ubuntu 18 can cause infinite udev loop of death if we install nvidia related services when the machine
# has no nvidia adapter on it
if [ $NVIDIA -gt 0 ];
then
    echo "[+] No NVIDIA graphics adapter found"
else
    if [ ! -f /lib/systemd/system/nvidia-persistenced.service ];
    then
        echo "[+] Setting up NVIDIA adapter"
        echo "[-] Enabling NVIDIA persistenced"
        /bin/cp $FILE_PATH/71-nvidia.rules /lib/udev/rules.d/71-nvidia.rules
        /bin/cp $FILE_PATH/nvidia-persistenced.service /lib/systemd/system/nvidia-persistenced.service
        /bin/systemctl daemon-reload
        /bin/systemctl enable nvidia-persistenced

        echo "[-] Generating Xorg settings for nvidia-settings"
	/usr/bin/nvidia-xconfig -a --allow-empty-initial-configuration --use-display-device="DFP-O:/etc/X11/edid.bin" --connected-monitor="DFP=O" --cool-bits=31

        echo "[-] Restarting udev"
        /bin/systemctl restart udev

    fi
fi

# Setting up AMD
echo "[+] Setting up AMD adapter"
echo "export LLVM_BIN=/opt/amdgpu-pro/bin" || tee /etc/profile.d/amdgpu-pro.sh


# Trying to detect the machine temperature and fan sensors
echo "[+] Setting up Sensors"
(while :; do echo ""; done) | /usr/sbin/sensors-detect &> /dev/null

# Mark that the setup completed
echo "[+] Setup complete"
echo " " > $PATH/.setup-completed

exit 0
