#!/bin/bash

sudo apt update
cp snapcraft.yaml ./snapcraft/snap/
cd ./snapcraft/
snapcraft clean dbeaverapp --step pull
pwd
snapcraft cleanbuild
pwd
snapcraft login --with ../snapcraft.login
#OUTPUT="$(ls -Art | tail -n 1)"
#snapcraft push $OUTPUT --release=stable
