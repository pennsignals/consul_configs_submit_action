#!/bin/sh

# Put config file into consul kv store
put_config() {
    ADDRESS="$1"
    CONSUL_PATH="$2"
    DEPLOY="$3"
    SERVICE="$4"
    FILE="$5"

    # rename file based on DEPLOY (ex sample.staging.yml -> sample.config.yml)
    FILE_NAME=$(echo ${FILE##*/} | sed 's/'"$DEPLOY"'/config/')

    # write config file at $CONSUL_PATH
    echo "curl -fX PUT --data-binary @$FILE $ADDRESS/$CONSUL_PATH/$SERVICE/$FILE_NAME"
    /usr/bin/curl -fX PUT --data-binary @$FILE $ADDRESS/$CONSUL_PATH/$SERVICE/$FILE_NAME

}


helpmenu() {
    echo "Usage submit_to_consul [options...] <dir>"
    echo " -h, --h              help menu"
    echo " -p, --path           consul kv destination path (default: \"\")"
    echo " -a, --address        consul destination address (default: \"http://10.146.0.5:8500/v1/kv\")"
    echo " -d, --deploy         deployment environment (default: \"staging\")"
    echo " -s, --service        service name (default: \"default\")"
}

get_all_configs() {

    # Get Variables then shift to start a files
    ADDRESS="$1"
    shift
    CONSUL_PATH="$1"
    shift
    DEPLOY="$1"
    shift
    SERVICE="$1"
    shift

    echo
    local f

    # send each config to put_config 
    echo "looking for *.$DEPLOY"
    for f; do
        echo "$0: uploading $f"
        put_config "$ADDRESS" "$CONSUL_PATH" "$DEPLOY" "$SERVICE" "$f"
        
        echo
    done
}

_main()
{
    # Set default values
    ADDRESS=http://10.146.0.5:8500/v1/kv
    CONSUL_PATH=/
    DEPLOY=staging
    SERVICE=default

    while [ ! $# -eq 0 ]
    do
        case "$1" in
            --help | -h)
                helpmenu
                exit
                ;;
            --path | -p)
                CONSUL_PATH="$2"
                shift
                ;;
            --address | -a)
                ADDRESS="$2"
                shift
                ;;
            --deploy | -d)
                DEPLOY="$2"
                shift
                ;;
            --service | -s)
                SERVICE="$2"
                shift
                ;;
            *)
                get_all_configs $ADDRESS $CONSUL_PATH $DEPLOY $SERVICE $@
                exit
                ;;
            -*)
                echo "Invalid option flag"
                helpmenu
                exit
                ;;
        esac
        shift
    done

    get_all_configs "$@"
}
_main "$@"
