#!/bin/bash

# Disable Nvidia completely if no video card found in the system
# This is for circumventing udev infinite loop bug in Ubuntu 18

if [ $(dmesg | grep "NVRM: No NVIDIA graphics adapter found!" | wc -l) -gt 0 ] ;
     then
       cp /lib/udev/rules.d/71-nvidia.rules /lib/udev/rules.d/71-nvidia.disabled
       systemctl disable nvidia-persistenced
       systemctl restart udev
     else
       /usr/bin/nvidia-xconfig -a --allow-empty-initial-configuration --use-display-device="DFP-0:/etc/X11/edid.bin" --connected-monitor="DFP-0" --cool-bits=31
fi

