#!/usr/bin/sh

DIRS="world config mods logs"
FILES="ops.json whitelist.json server.properties modlist.txt banned-ips.json banned-players.json"

for dir in $DIRS; do
  rmdir ${dir} 2>/dev/null
  mkdir /data/${dir} 2>/dev/null
  ln -s /data/${dir} 2>/dev/null
done

for file in $FILES; do
  rm ${file} 2>/dev/null
  touch /data/${file} 2>/dev/null
  ln -s /data/${file} 2>/dev/null
done

../scripts/run/mods.sh

java "-Xms${MINMEM}" "-Xmx${MAXMEM}" -jar $SERVER_JARPATH
