#!/usr/bin/env bash

set -e

MCOPY_URL='https://github.com/mritd/init/raw/master/mmh/mcopy'

function install_mcopy(){
    info "install mcopy..."
    curl -sSL ${MCOPY_URL} > /usr/local/bin/mcopy
    chmod +x /usr/local/bin/mcopy
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

install_mcopy
