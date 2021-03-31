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

# download yq and consul
RUN wget -qO /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${BINARY} &&\
    wget -qO /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_${BINARY}.zip

# install yq and consul
RUN chmod +x /usr/bin/yq &&\
    unzip /tmp/consul.zip -d /usr/local/bin/

ENTRYPOINT [ "/entrypoint.sh" ]