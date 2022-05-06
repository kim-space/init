#!/usr/bin/env bash

set -e

function init_ssh(){
    info "Enable root login..."
    cat > /etc/ssh/sshd_config.d/10-sshd-init.conf <<EOF
PermitRootLogin yes
AcceptEnv ENABLE_VIM_CONFIG MMH*
EOF
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

init_ssh
