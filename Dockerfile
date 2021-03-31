ARG CONSUL_VERSION=1.8.5 
ARG YQ_VERSION=3.4.1
ARG BINARY=linux_amd64

FROM debian:10.6-slim as consul

LABEL name=consul

ARG CONSUL_VERSION
ARG YQ_VERSION
ARG BINARY

RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    unzip

ADD entrypoint.sh /entrypoint.sh
ADD ./src/submit_to_consul.sh /scripts/submit_to_consul.sh

# install yq
RUN wget -qO /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${BINARY} &&\
    chmod +x /usr/bin/yq

# install consul
RUN wget -qO consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_${BINARY}.zip &&\
    unzip consul.zip -d /usr/local/bin/

ENTRYPOINT [ "/entrypoint.sh" ]