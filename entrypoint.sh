#!/bin/sh

# echo all the variabls
echo "INPUT_ADDR: $INPUT_ADDR"
echo "INPUT_PATH: $INPUT_PATH"
echo "INPUT_REGEX: $INPUT_REGEX"
echo "INPUT_LOCATION: $INPUT_LOCATION"

# find all files in subdirectories of location
CONFIG_FILES=$(find "${INPUT_LOCATION}" -type f -regextype posix-extended -regex "${INPUT_REGEX}")

/scripts/submit_to_consul.sh --path "${INPUT_PATH}" --address "${INPUT_ADDR}" "${CONFIG_FILES}"
