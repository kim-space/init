#!/usr/bin/env bash

set -ex

DOWNLOAD_URL=`curl -s https://api.github.com/repos/containerd/nerdctl/releases/latest | jq -r ".assets[] | select((.name | contains(\"full\")) and (.name | contains(\"$(uname -m)\"))) | .browser_download_url"`

echo ${DOWNLOAD_URL}

function install_nerdctl(){
    info "install nerdctl..."
    wget ${DOWNLOAD_URL} -O nerdctl.tar.gz
    tar Cxzvvf /usr/local nerdctl.tar.gz
    systemctl enable --now containerd
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
