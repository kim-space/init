#!/usr/bin/env bash

set -e

BACKUP_TIMESTAMP=$(date "+%Y%m%d%H%M%S")
PREZTO_REPO='https://github.com/sorin-ionescu/prezto.git'
ZPROFILE_URL='https://github.com/mritd/init/raw/master/prezto/zprofile'
ZPREZTORC_URL='https://github.com/mritd/init/raw/master/prezto/zpreztorc'
ZSHRC_URL='https://github.com/mritd/init/raw/master/prezto/zshrc'

COMPLETION_PRLCTL='https://raw.githubusercontent.com/zchee/zsh-completions/main/src/zsh/_prlctl'
COMPLETION_PRLSRVCTL='https://raw.githubusercontent.com/zchee/zsh-completions/main/src/zsh/_prlsrvctl'
COMPLETION_DOCKER='https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker'

function pre_check(){
    if ! command -v zsh >/dev/null 2>&1; then
        err "zsh is not installed, please install zsh before init."
        exit 1
    fi
}

function change_default_shell(){
    info "change default shell to zsh..."
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
}

function install_prezto(){
    info "install prezto..."
    zdot_home="${ZDOTDIR:-$HOME}/.zprezto"
    if [[ -d "${zdot_home}" ]]; then
        warn "backup [${zdot_home}] to [${zdot_home}-${BACKUP_TIMESTAMP}]"
        mv "${zdot_home}" "${zdot_home}-${BACKUP_TIMESTAMP}"
    fi

    git clone --recursive ${PREZTO_REPO} "${zdot_home}" 

    info "swicth zsh-history-substring-search to master branch..."
    (cd ${zdot_home}/modules/history-substring-search/external && git checkout master)

    info "link config..."
    for rcfile in $(ls ${ZDOTDIR:-$HOME}/.zprezto/runcoms/* | xargs -n 1 basename | grep -v README); do
        target="${ZDOTDIR:-$HOME}/.${rcfile:t}"
        if [[ -f "${target}" ]]; then
            warn "backup [${target}] to [${target}-${BACKUP_TIMESTAMP}]"
            mv "${target}" "${target}-${BACKUP_TIMESTAMP}"
        fi
        ln -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/${rcfile}" "${target}"
    done
}

function install_cutom_config(){
    info "install cutom config..."
    curl -sSL ${ZPROFILE_URL} > "${ZDOTDIR:-$HOME}/.zprofile"
    curl -sSL ${ZPREZTORC_URL} > "${ZDOTDIR:-$HOME}/.zpreztorc"
    curl -sSL ${ZSHRC_URL} > "${ZDOTDIR:-$HOME}/.zshrc"
    curl -sSL ${COMPLETION_PRLCTL} > "${ZDOTDIR:-$HOME}/.zprezto/modules/completion/external/src/_prlctl"
    curl -sSL ${COMPLETION_PRLSRVCTL} > "${ZDOTDIR:-$HOME}/.zprezto/modules/completion/external/src/_prlsrvctl"
    curl -sSL ${COMPLETION_DOCKER} > "${ZDOTDIR:-$HOME}/.zprezto/modules/completion/external/src/_docker"
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

pre_check
change_default_shell
install_prezto
install_cutom_config
