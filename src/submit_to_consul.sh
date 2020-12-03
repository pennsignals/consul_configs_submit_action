#!/bin/sh

# Put config file into consul kv store
put_config() {
    ADDRESS="$1"
    CONSUL_PATH="$2"
    DEPLOY="$3"
    FILE="$4"

    # rename file based on DEPLOY (ex sample.staging.yml -> sample.config.yml)
    FILE_NAME=$(echo ${FILE##*/} | sed 's/staging/config/')

    # write config file at $CONSUL_PATH
    echo "curl -fX PUT -d @$FILE $ADDRESS/$CONSUL_PATH/$FILE_NAME"
    /usr/bin/curl -fX PUT -d @$FILE $ADDRESS/$CONSUL_PATH/$FILE_NAME

}


helpmenu() {
    echo "Usage submit_to_consul [options...] <dir>"
    echo " -h, --h              help menu"
    echo " -p, --path           consul kv destination path (default: \"\")"
    echo " -a, --address        consul destination address (default: \"http://10.146.0.5:8500/v1/kv\")"
    echo " -d, --deploy         deployment environment (default: \"staging\")"

}

get_all_configs() {

    # Get Variables then shift to start a files
    ADDRESS="$1"
    shift
    CONSUL_PATH="$1"
    shift
    DEPLOY="$1"
    shift

    echo
    local f
    # check each file for regex (matching deploy env)
    echo "looking for *.$DEPLOY"
    for f; do
        case "$f" in
            *.${DEPLOY}.*) echo "$0: uploading $f"; put_config "$ADDRESS" "$CONSUL_PATH" "$DEPLOY" "$f"; echo ;;
            *)      echo "$0: ignoring $f" ;;
        esac
        echo
    done
}

_main()
{
    # Set default values
    ADDRESS=http://10.146.0.5:8500/v1/kv
    CONSUL_PATH=/
    DEPLOY=staging

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
            *)
                #echo "$ADDRESS, $CONSUL_PATH", "$DEPLOY"
                #echo "$@"
                get_all_configs $ADDRESS $CONSUL_PATH $DEPLOY $@
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
