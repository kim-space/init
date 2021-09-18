#!/usr/bin/env bash

set -e

TMUX_CONFIG_URL='https://github.com/mritd/init/raw/master/tmux/tmux.conf'
TPM_REPO_URL='https://github.com/tmux-plugins/tpm'

function install_tmux(){
    info "install tmux..."
    if [[ "$OSTYPE" =~ ^darwin ]]; then
        brew install tmux
    elif [[ "$OSTYPE" =~ ^linux ]]; then
        apt install tmux -y
    else
        err "unsupport os type!"
        exit 1
    fi
}

function install_gitmux(){
    info "install gitmux..."
    go install github.com/arl/gitmux@master
}

function install_tpm(){
    info "install tpm..."
    git clone ${TPM_REPO_URL} ~/.tmux/plugins/tpm
}

function install_config(){
    info "install tmux config..."
    curl -sSL ${TMUX_CONFIG_URL} > ~/.tmux.conf
}

function install_tpm_plugins(){
    info "install tpm plugins..."
    ~/.tmux/plugins/tpm/bin/install_plugins
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

install_tmux
install_gitmux
install_tpm
install_config
install_tpm_plugins
