# JXOS - Mining Operating System

This is the script for generating JXOS iso files. The script is used at the JXOS development process thus it might change frequently.
No guarantee that the script will work at any given time, to use JXOS download the build iso instead.

Warning: Please use this script under VirtualManager disks, it has the potential of destroying your system!

# Prequisite

The script is expected to run under Ubuntu machine with the following installed:
1. Python pip
2. chroot ability
3. mkisofs
4. mksquashfs
5. apt
6. bash
7. rsync
8. others...

A working network connection is required as the script will try to rsync the connection to the chrooted environment to download additional packages.

You might need to create these folders manually :
1. source
2. temp
3. workspace

# Usage

build.sh - Auto invoke all the child scripts
prepare.sh - Preparing the chrooted environment with base ubuntu
activate.sh - Populating the chrooted environment with networking and dev
deactivate.sh - Depopulating the chrooted environment and clean it up
generate.sh - Populating chrooted environment with packages and settings
packing.sh - Pack the chrooted environment to squashfs
finalize.sh - Create the iso file


