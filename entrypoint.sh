#!/bin/sh

# echo all the variabls
echo "CONSUL_HTTP_ADDR: $CONSUL_HTTP_ADDR"
echo "DEPLOY_CONFIG: $DEPLOY_CONFIG"
echo "ENV: $ENV"

# parse DEPLOY_CONFIG file and build PATH
ORGANIZATION=$(yq read $DEPLOY_CONFIG 'organization')
PROJECT=$(yq read $DEPLOY_CONFIG 'project')
SERVICES=$(yq read --printMode p $DEPLOY_CONFIG 'services.*.' | cut -f2 -d '.')

# go through each SERVICE
for SERVICE in $(echo $SERVICES | sed "s/,/ /g"); do
    echo "Service: $SERVICE"

    # get file based on environenment (staging / production)
    CONFIG_FILE=$(yq read $DEPLOY_CONFIG services.$SERVICE.location)/$(yq read $DEPLOY_CONFIG template.configs.location)/$(yq read $DEPLOY_CONFIG services.$SERVICE.configuration.local.$ENV)
    
    # set filename to .configuration.name
    FILE_NAME=$(yq read $DEPLOY_CONFIG services.$SERVICE.configuration.name)

    # submit to consul
    consul kv put $ORGANIZATION/$PROJECT/$SERVICE/$FILE_NAME @$CONFIG_FILE

done
