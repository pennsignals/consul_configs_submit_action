#!/bin/sh

# echo all the variabls
echo "CONSUL_ADDR: $CONSUL_ADDR"
echo "DEPLOY_CONFIG: $DEPLOY_CONFIG"

# parse DEPLOY_CONFIG file and build VAULT_PATH
DEPLOY=$(yq read $DEPLOY_CONFIG 'deploy')
CONSUL_PATH=$(yq read $DEPLOY_CONFIG 'organization')/$(yq read $DEPLOY_CONFIG 'project')
SERVICES=$(yq read --printMode p $DEPLOY_CONFIG 'services.*.' | cut -f2 -d '.')
REGEX=$(yq read $DEPLOY_CONFIG 'template.configs.regex')

# go through each SERVICE
for SERVICE in $(echo $SERVICES | sed "s/,/ /g"); do
    echo "Service: $SERVICE"

    # build CONSUL PATH
    CONFIGS_PATH=$(yq read $DEPLOY_CONFIG services.$SERVICE.location)/$(yq read $DEPLOY_CONFIG template.configs.location)

    # find all config files matching regex file extension and deploy environement (example staging.yml)
    CONFIG_FILES=$(find "${CONFIGS_PATH}" -type f -regextype posix-extended -regex "${REGEX}" -and -regex ".*.${DEPLOY}.*")

    # submit all found config files to consul
    echo "/scripts/submit_to_consul.sh --path ${CONSUL_PATH} --address ${CONSUL_ADDR} --deploy ${DEPLOY} --service "${SERVICE}" ${CONFIG_FILES}"
    /scripts/submit_to_consul.sh --path "${CONSUL_PATH}" --address "${CONSUL_ADDR}" --deploy "${DEPLOY}" --service "${SERVICE}" "${CONFIG_FILES}"

done
