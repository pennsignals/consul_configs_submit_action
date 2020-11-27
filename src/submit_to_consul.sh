#!/bin/sh

# Put config file into consul kv store
put_config() {
    ADDRESS="$1"
    PATH="$2"
    FILE="$3"

    # First we need the token
    #echo "ADDRESS:\t$ADDRESS\nPATH:\t\t$PATH\nFILE:\t\t$FILE"
    # CONSUL_HTTP_TOKEN=$(curl $CONSUL_ADDR/service/consul/bootstrap-token | jq -r '.[] | .Value') && echo $CONSUL_HTTP_TOKEN

    # # Now write all config files at $PATH
    FILE_NAME=${FILE##*/}
    #echo $FILE_NAME
    echo "curl -fX PUT -d @$FILE $ADDRESS/$PATH/$FILE_NAME"
    /usr/bin/curl -fX PUT -d @$FILE $ADDRESS/$PATH/$FILE_NAME

    # curl -fX PUT -d @./local/appsettings.json http://10.146.0.5:8500/v1/kv/postgres/appsettings.json

}


helpmenu() {
    echo "Usage submit_to_consul [options...] <dir>"
    echo " -h, --h              help menu"
    echo " -p, --path           consul kv destination path (default: \"\")"
    echo " -a, --address        consul destination address (default: \"http://10.146.0.5:8500/v1/kv\")"

}

get_all_configs() {

    # Get Variables then shift to start a files
    ADDRESS="$1"
    shift
    PATH="$1"
    shift

    echo
    local f
    for f; do
        case "$f" in
            *.json) echo "$0: uploading $f"; put_config "$ADDRESS" "$PATH" "$f"; echo ;;
            *.yml)  echo "$0: uploading $f"; put_config "$ADDRESS" "$PATH" "$f"; echo ;;
            *.yaml)  echo "$0: uploading $f"; put_config "$ADDRESS" "$PATH" "$f"; echo ;;
            *.properties)  echo "$0: uploading $f"; put_config "$ADDRESS" "$PATH" "$f"; echo ;;
            *.conf)  echo "$0: uploading $f"; put_config "$ADDRESS" "$PATH" "$f"; echo ;;
            *.xml)  echo "$0: uploading $f"; put_config "$ADDRESS" "$PATH" "$f"; echo ;;
            *)      echo "$0: ignoring $f" ;;
        esac
        echo
    done
}

_main()
{
    # Set default values
    ADDRESS=http://10.146.0.5:8500/v1/kv
    PATH=/

    while [ ! $# -eq 0 ]
    do
        case "$1" in
            --help | -h)
                helpmenu
                exit
                ;;
            --path | -p)
                PATH="$2"
                shift
                ;;
            --address | -a)
                ADDRESS="$2"
                shift
                ;;
            *)
                echo "$ADDRESS, $PATH"
                echo "$@"
                get_all_configs $ADDRESS $PATH $@
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
