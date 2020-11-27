FROM debian:10.6-slim

RUN apt-get update && \
    apt-get install -y \
    curl

ADD ./src/entrypoint.sh /entrypoint.sh
ADD submit_to_consul.sh /submit_to_consul.sh

ENTRYPOINT [ "/entrypoint.sh" ]