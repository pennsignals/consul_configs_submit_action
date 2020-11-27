#!/bin/sh

# find all files in subdirectories of location
CONFIG_FILES=$(find "$INPUT_LOCATION" -type f -regextype posix-extended -regex "$INPUT_REGEX")

submit_to_consul.sh --path "${INPUT_PATH}" --address "${INPUT_ADDR}" "${CONFIG_FILES}"
