#!/usr/bin/sh

DIRS="world config logs"
FILES="ops.json whitelist.json server.properties modlist.txt banned-ips.json banned-players.json"

for dir in $DIRS; do
  rm -r ${dir} 2>/dev/null
  mkdir -p /data/${dir} 2>/dev/null
  ln -s /data/${dir} 2>/dev/null
done

mkdir /data/usermods 2>/dev/null
mkdir mods 2>/dev/null
ln -s /data/usermods mods/user

for file in $FILES; do
  rm ${file} 2>/dev/null
  touch /data/${file} 2>/dev/null
  ln -s /data/${file} 2>/dev/null
done

../scripts/run/mods.sh

echo "eula=${EULA}" > eula.txt
java "-Xms${MINMEM}" "-Xmx${MAXMEM}" -jar $FABRIC_SERVER_JAR
