#!/bin/bash

SOURCES=(
  ${GAIA_PATH-"$HOME/repository/gaia/"}
  ${GECKO_PATH-"$HOME/repository/gecko-dev/"}
)

for path in ${SOURCES[@]}
do
  echo "mkid $path"
  cd $path
  mkid -m idmap.txt "$path" # 2>/dev/null 1>/dev/null
done
