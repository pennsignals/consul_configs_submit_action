FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y \
    curl

ADD entrypoint.sh /entrypoint.sh
ADD ./src/submit_to_consul.sh /scripts/submit_to_consul.sh

ENTRYPOINT [ "/entrypoint.sh" ]