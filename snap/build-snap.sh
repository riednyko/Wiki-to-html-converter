i#!/bin/bash

cp snapcraft.yaml ./snapcraft/snap/
cd ./snapcraft/
snapcraft clean dbeaver-ce --step pull
snapcraft cleanbuild
snapcraft login --with exported
OUTPUT="$(ls -Art | tail -n 1)"
snapcraft push $OUTPUT --release=stable
