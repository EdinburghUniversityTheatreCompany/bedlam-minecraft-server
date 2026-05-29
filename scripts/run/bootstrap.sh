#!/usr/bin/sh

# for some reason there's a trailing newline and for some reason ferium doesn't strip it.
export GITHUB_TOKEN=$(cat /run/secrets/github_token)
export GITHUB_TOKEN=$(echo "${GITHUB_TOKEN}" | xargs)

chown -R minecraft /data
gosu minecraft:minecraft $1
