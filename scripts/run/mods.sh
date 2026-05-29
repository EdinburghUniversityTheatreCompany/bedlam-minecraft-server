#!/usr/bin/sh

ferium profile create -n default -m fabric -v ${MC_V} -o $(realpath mods)

while IFS="" read -r modid || [ -n "$modid" ]; do
    echo $modid
    if case $modid in "#"*) false;; *) true;; esac; then
        ferium add $modid
    fi
done < modlist.txt

ferium upgrade
