i#!/bin/bash

cp snapcraft.yaml ./snapcraft/snap/
cd ./snapcraft/
snap install lxd
snapcraft clean dbeaver-ce --step pull
snapcraft cleanbuild
snapcraft login
OUTPUT="$(ls -Art | tail -n 1)"
snapcraft push $OUTPUT --release=stable
