#!/bin/bash

# Run this script to setup Nvidia, only if your machine has Nvidia cards on it

cp ../files/71-nvidia.rules /lib/udev/rules.d/71-nvidia.rules
cp ../files/nvidia-persistenced.service /lib/systemd/system/nvidia-persistenced.service
systemctl enable nvidia-persistenced
/usr/bin/nvidia-xconfig -a --allow-empty-initial-configuration --use-display-device="DFP-0:/etc/X11/edid.bin" --connected-monitor="DFP-0" --cool-bits=3
systemctl restart udev



