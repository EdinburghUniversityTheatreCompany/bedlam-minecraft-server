#!/usr/bin/sh

chown -R minecraft /data
gosu minecraft:minecraft $1
