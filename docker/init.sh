#!/usr/bin/env bash

set -e

OS_RELEASE="$(lsb_release -cs)"
USE_APT_MIRROR=${USE_APT_MIRROR-"true"}
DOCKER_APT_LIST_URL="https://raw.githubusercontent.com/mritd/init/master/docker/docker.list"
DOCKER_SYSTEMD_CONFIG_URL="https://raw.githubusercontent.com/mritd/init/master/docker/docker.service"
DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)"

backup_timestamp=$(date "+%Y%m%d%H%M%S")

function install_docker(){
    info "install docker..."
    apt install docker.io -y
    apt-mark hold docker docker.io containerd

    curl -sSL ${DOCKER_SYSTEMD_CONFIG_URL} > docker.service
    SYSTEMD_EDITOR="mv docker.service" systemctl edit docker
    systemctl daemon-reload && systemctl restart docker && systemctl enable docker
}

function install_compose(){
    info "install docker-compose..."

    mkdir -p /usr/local/lib/docker/cli-plugins/
    curl -sSL ${DOCKER_COMPOSE_URL} > /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
}

function info(){
    echo -e "\033[32mINFO: $@\033[0m"
}

function warn(){
    echo -e "\033[33mWARN: $@\033[0m"
}

function err(){
    echo -e "\033[31mERROR: $@\033[0m"
}

install_docker
install_compose
