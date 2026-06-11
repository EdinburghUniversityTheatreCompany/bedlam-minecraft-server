#!/usr/bin/sh

./scripts/build/user.sh

chown -R minecraft:minecraft /opt/app/minecraft

echo "${MC_V}" > mc-version.txt
