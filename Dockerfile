FROM debian:10.6-slim as consul
LABEL name=consul

ARG VERSION="3.4.1"
ARG BINARY="yq_linux_amd64"

RUN apt-get update && \
    apt-get install -y \
    curl \
    wget

ADD entrypoint.sh /entrypoint.sh
ADD ./src/submit_to_consul.sh /scripts/submit_to_consul.sh

# install yq
RUN wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

ENTRYPOINT [ "/entrypoint.sh" ]