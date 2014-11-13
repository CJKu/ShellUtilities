#!/bin/bash

SOURCES=(
  ${GAIA_PATH-'../gaia/'}
  ${GECKO_PATH-'../gecko-dev/'}
)

for path in ${SOURCES[@]}
do
  echo "mkid $path"
  mkid -m idmap.txt "$path" # 2>/dev/null 1>/dev/null
done
