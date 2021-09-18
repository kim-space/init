#!/usr/bin/env bash

set -e

BACKUP_TIMESTAMP=$(date "+%Y%m%d%H%M%S")
ZPREZTORC_URL='https://github.com/mritd/init/raw/master/prezto/zpreztorc'
ZSHRC_URL='https://github.com/mritd/init/raw/master/prezto/zshrc'

function install_zsh(){
    info "install zsh..."
    if [[ "$OSTYPE" =~ ^linux ]]; then
        apt install zsh -y
    else
        err "unsupport os type!"
        exit 1
    fi

    info "change default shell to zsh..."
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
}

function install_prezto(){
    info "install prezto..."
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

    info "link config..."
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        target="${ZDOTDIR:-$HOME}/.${rcfile:t}"
        if [[ -f "${target}" ]]; then
            warn "backup [${target}] to [${target}-${BACKUP_TIMESTAMP}]"
            mv "${target}" "${target}-${BACKUP_TIMESTAMP}"
        fi
        ln -s "$rcfile" "${target}"
    done
}

function install_cutom_config(){
    info "install cutom config..."
    curl -sSL ${ZPREZTORC_URL} > "${ZDOTDIR:-$HOME}/.zpreztorc"
    curl -sSL ${ZSHRC_URL} > "${ZDOTDIR:-$HOME}/.zshrc"
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

install_zsh
install_prezto
install_cutom_config
