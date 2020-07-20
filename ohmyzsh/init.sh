#!/usr/bin/env bash

set -e

GITHUB_HOST=${GITHUB_HOST-"github.com"}
GITHUB_RAW_HOST=${GITHUB_RAW_HOST-"raw.githubusercontent.com"}
OHMYZSH_URL="https://${GITHUB_HOST}/robbyrussell/oh-my-zsh.git"
OHMYZSH_CONFIG_URL="https://${GITHUB_RAW_HOST}/mritd/init/master/ohmyzsh/zshrc"
SYNTAX_HIGHLIGHTING_URL="https://${GITHUB_HOST}/zsh-users/zsh-syntax-highlighting.git

backup_timestamp=$(date "+%Y%m%d%H%M%S")

function backup_config(){
    info "backup old config..."
    if [ -f ~/.zshrc ]; then
        warn "backup [~/.zshrc] to [~/.zshrc-${backup_timestamp}]"
        mv ~/.zshrc ~/.zshrc-${backup_timestamp}
    fi
    if [ -d ~/.oh-my-zsh ]; then
        warn "backup [~/.oh-my-zsh] to [~/.oh-my-zsh-${backup_timestamp}]"
        mv ~/.oh-my-zsh ~/.oh-my-zsh-${backup_timestamp}
    fi
}

function install_ohmyzsh(){
    info "install zshrc..."
    curl -sSL ${OHMYZSH_CONFIG_URL} > ~/.zshrc
    info "install ohmyzsh..."
    git clone --depth=1 ${OHMYZSH_URL} ~/.oh-my-zsh
    info "change default shell to zsh..."
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
}

function install_syntax_highlighting(){
    info "install zsh-syntax-highlighting..."
    git clone ${SYNTAX_HIGHLIGHTING_URL} ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
}

function info(){
    echo -e "\033[32mINFO: $@\033[0m"
}

function warn(){
    echo -e "\033[33mWARN: $@\033[0m"
}

backup_config
install_ohmyzsh
install_syntax_highlighting
