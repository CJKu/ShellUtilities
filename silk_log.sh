#!/bin/bash
# A tool to parse gecko log and retrieve silk log
#

if [ -z $1 ]; then
  echo "Input filename missed."
  exit 1
fi

# The name of source log file
IN=$1
# The name of output field file
# default output filename is "output.txt"
OUT=${2:-output.txt}

echo "Generate and put field data into \"${OUT}\""

# sample name
LOG_NAME="Silk input resample"
SILK_LOG_PATTERN="s/.*${LOG_NAME} *, *\([0-9]*\) *, *\([.0-9]*\).*/\1 \2/"

# Convert log string into two fields: frame number + distance
# For example,
# "I/Gecko   ( 6418): Silk input resample , 196827, 0.030"
# tunrs into
# "196827 0.030"
sed -n "/${LOG_NAME}/p" "${1}" | sed "${SILK_LOG_PATTERN}" > ${OUT}

echo "Done..."
