#!/usr/bin/env bash

set -e

GITHUB_HOST=${GITHUB_HOST-"github.com"}
TERMSHARK_URL="https://${GITHUB_HOST}/gcla/termshark/releases/download/v2.1.1/termshark_2.1.1_linux_x64.tar.gz"

function install_termshark(){
    info "install termshark..."
    curl -fsSL ${TERMSHARK_URL} > termshark.tar.gz
    tar -zxf termshark.tar.gz
    mv termshark*/termshark /usr/local/bin/termshark
    chmod +x /usr/local/bin/termshark
    rm -rf termshark*
    apt install tshark -y
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

install_termshark
