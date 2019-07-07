#!/bin/bash
# This script will remove all the previously generate content

./reset.sh
./prepare.sh
./generate.sh
./packing.sh
./finalize.sh
