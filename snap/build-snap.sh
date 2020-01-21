i#!/bin/bash

mkdir ./mysnaps/snap
cp ../snapcraft.yaml mysnaps/snap/
cd ~/mysnaps/jenkins
snapcraft clean dbeaver-ce --step pull
snapcraft cleanbuild
snapcraft login
OUTPUT="$(ls -Art | tail -n 1)"
snapcraft push $OUTPUT --release=stable
