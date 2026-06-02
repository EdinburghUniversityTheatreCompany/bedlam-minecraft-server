#!/usr/bin/sh

chown -R minecraft:minecraft /data
gosu minecraft:minecraft $1
