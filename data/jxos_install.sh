# Force Console mode
#echo "GRUB_TERMINAL=console" >> /etc/default/grub
#update-grub

#DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y --force-yes linux-image-4.13.0-45-generic linux-headers-4.13.0-45-generic linux-image-extra-4.13.0-45-generic -o Dpkg::Options::="--force-confdef"

/usr/bin/pip install /opt/jxos/pip/*

# Configuring nodm
/bin/sed -i 's/NODM_ENABLED=false/NODM_ENABLED=true' /etc/default/nodm
/bin/sed -i 's/NODM_USER=root/NODM_USER=jxminer' /etc/default/nodm

cp -f /opt/jxos/files/edid.bin /etc/X11
/usr/bin/nvidia-xconfig -a --allow-empty-initial-configuration --use-display-device="DFP-0:/etc/X11/edid.bin" --connected-monitor="DFP-0" --cool-bits=31

echo "export LLVM_BIN=/opt/amdgpu-pro/bin" || tee /etc/profile.d/amdgpu-pro.sh

# Configuring sensors-detect
(while :; do echo ""; done) | sensors-detect
