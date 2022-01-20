#!/usr/bin/env bash

set -e

DOWNLOAD_URL=`curl -s https://api.github.com/repos/containerd/nerdctl/releases/latest | jq -r ".assets[] | select((.name | contains(\"full\")) and (.name | contains(\"$(dpkg --print-architecture)\"))) | .browser_download_url"`

function install_nerdctl(){
    info "install nerdctl..."
    wget ${DOWNLOAD_URL} -O nerdctl.tar.gz
    tar Cxzvvf /usr/local nerdctl.tar.gz
    systemctl enable --now containerd
    rm -f nerdctl.tar.gz
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

install_nerdctl
