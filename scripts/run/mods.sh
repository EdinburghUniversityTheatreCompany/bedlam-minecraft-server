#!/usr/bin/sh

ferium profile rm default 2>/dev/null
ferium profile create -n default -m fabric -v $(cat mc-version.txt) -o $(realpath mods)

while IFS="" read -r modid || [ -n "$modid" ]; do
    if case $modid in "#"*) false;; *) true;; esac; then
        ferium add $modid
    fi
done < modlist.txt

ferium upgrade
