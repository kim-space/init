#!/usr/bin/env bash

set -e

HEY_URL='https://storage.googleapis.com/hey-release/hey_linux_amd64'

function install_hey(){
    info "install hey..."
    curl -sSL ${HEY_URL} > /usr/local/bin/hey
    chmod +x /usr/local/bin/hey
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

install_hey
