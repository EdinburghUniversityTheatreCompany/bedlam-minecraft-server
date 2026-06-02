#!/usr/bin/sh

groupadd minecraft -g 966
useradd -rm -g minecraft minecraft -u 1966
chown -R minecraft:minecraft /opt/app/minecraft

echo "${MC_V}" > mc-version.txt
