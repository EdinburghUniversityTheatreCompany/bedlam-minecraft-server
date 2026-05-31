#!/usr/bin/sh

groupadd minecraft
useradd -rm -g minecraft minecraft
chown -R minecraft /opt/app/minecraft

echo "${MC_V}" > mc-version.txt
