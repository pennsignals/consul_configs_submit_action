#!/bin/sh

# echo all the variabls
echo "INPUT_ADDR: $INPUT_ADDR"
echo "INPUT_PATH: $INPUT_PATH"
echo "INPUT_REGEX: $INPUT_REGEX"
echo "INPUT_LOCATIONS: $INPUT_LOCATIONS"
echo "INPUT_DEPLOY: $INPUT_DEPLOY"

# go through each Search Location
echo "Searching: $INPUT_LOCATIONS"
for INPUT_LOCATION in $(echo $INPUT_LOCATIONS | sed "s/,/ /g"); do


    # find all files in subdirectories of location
    CONFIG_FILES=$(find "${INPUT_LOCATION}" -type f -regextype posix-extended -regex "${INPUT_REGEX}")

    # submit all found config files to consul
    echo "/scripts/submit_to_consul.sh --path ${INPUT_PATH} --address ${INPUT_ADDR} --deploy ${INPUT_DEPLOY} ${CONFIG_FILES}"
    /scripts/submit_to_consul.sh --path "${INPUT_PATH}" --address "${INPUT_ADDR}" --deploy "${INPUT_DEPLOY}" "${CONFIG_FILES}"

done