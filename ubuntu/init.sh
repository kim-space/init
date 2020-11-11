#!/usr/bin/env bash

set -e

OS_RELEASE="$(lsb_release -cs)"
OS_TIMEZONE=${OS_TIMEZONE-"Asia/Shanghai"}
GITHUB_HOST=${GITHUB_HOST-"github.com"}
GITHUB_RAW_HOST=${GITHUB_RAW_HOST-"raw.githubusercontent.com"}
USE_APT_MIRROR=${USE_APT_MIRROR-"true"}
SOURCES_LIST_URL="https://${GITHUB_RAW_HOST}/mritd/init/master/ubuntu/sources.list"

backup_timestamp=$(date "+%Y%m%d%H%M%S")

function setlocale(){
    info "set system locale..."
    warn "backup [/etc/locale.gen] to [/etc/locale.gen-${backup_timestamp}]"
    mv /etc/locale.gen /etc/locale.gen-${backup_timestamp}
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
    echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen
    locale-gen --purge
    localectl set-locale LANG=en_US.UTF-8
}

function sysupdate(){
    info "update system packages..."
    if [ "${USE_APT_MIRROR}" == "true" ]; then
        warn "backup [/etc/apt/sources.list] to [/etc/apt/sources.list-${backup_timestamp}]"
        mv /etc/apt/sources.list /etc/apt/sources.list-${backup_timestamp}
        curl -sSL ${SOURCES_LIST_URL} | sed "s@{{OS_RELEASE}}@${OS_RELEASE}@gi" > /etc/apt/sources.list
    fi
    apt update -y
    apt upgrade -y
    info "install custom packages..."
    apt install -y apt-transport-https ca-certificates software-properties-common \
        wget vim zsh git htop tzdata conntrack ipvsadm ipset stress sysstat axel \
        nload net-tools tree
    apt autoremove -y
    apt autoclean -y
}

function settimezone(){
    info "set system timezone to [${OS_TIMEZONE}]..."
    timedatectl set-timezone ${OS_TIMEZONE}
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

setlocale
sysupdate
settimezone
