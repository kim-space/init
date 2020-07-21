#!/usr/bin/env bash

set -e

OS_RELEASE="$(lsb_release -cs)"
GITHUB_HOST=${GITHUB_HOST-"github.com"}
GITHUB_RAW_HOST=${GITHUB_RAW_HOST-"raw.githubusercontent.com"}
USE_APT_MIRROR=${USE_APT_MIRROR-"true"}
DOCKER_APT_LIST_URL="https://${GITHUB_RAW_HOST}/mritd/init/master/docker/docker.list"
DOCKER_SYSTEMD_CONFIG_URL="https://${GITHUB_RAW_HOST}/mritd/init/master/docker/docker.service"
DOCKER_COMPOSE_URL="https://${GITHUB_HOST}/docker/compose/releases/download/1.26.2/docker-compose-Linux-x86_64"

backup_timestamp=$(date "+%Y%m%d%H%M%S")

function install_docker(){
    info "install docker..."
    if [ "${OS_RELEASE}" == "focal" ]; then
        apt install docker.io -y
        apt-mark hold docker.io
    else
        if [ "${USE_APT_MIRROR}" == "true" ]; then
            info "use aliyun docker apt mirror..."
            curl -sSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
            curl -sSL ${DOCKER_LIST_URL} | sed "s@{{OS_RELEASE}}@${OS_RELEASE}@gi" > /etc/apt/sources.list.d/docker.list
        else
            curl -sSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${OS_RELEASE} stable" > /etc/apt/sources.list.d/docker.list
        fi
        apt update -y
        apt install docker-ce -y
        apt-mark hold docker-ce
    fi

    curl -sSL ${DOCKER_SYSTEMD_CONFIG_URL} > docker.service
    SYSTEMD_EDITOR="mv docker.service" systemctl edit docker
    systemctl daemon-reload && systemctl restart docker
}

function install_compose(){
    info "install docker-compose..."
    curl -sSL ${DOCKER_COMPOSE_URL} > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
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
