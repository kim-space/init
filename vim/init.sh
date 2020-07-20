#!/usr/bin/env bash

ENABLE_VIM_CONFIG="true"
VIM_CONFIG_URL="https://raw.githubusercontent.com/mritd/init/master/vim/vimrc"
VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
VIM_PLUG_CONFIG_URL="https://raw.githubusercontent.com/mritd/init/master/vim/vim_plug"

function backup_config(){
    info "backup old config..."
    backup_timestamp=$(date "+%Y%m%d%H%M%S")
    if [ -f ~/.vimrc ]; then
        warn "backup [~/.vimrc] to [~/.vimrc-${backup_timestamp}]"
        mv ~/.vimrc ~/.vimrc-${backup_timestamp}
    fi
    if [ -d ~/.vim ]; then
        warn "backup [~/.vim] to [~/.vim-${backup_timestamp}]"
        mv ~/.vim ~/.vim-${backup_timestamp}
    fi
}

function install_plug(){
    info "install vim-plug..."
    curl -sSLo ~/.vim/autoload/plug.vim --create-dirs ${VIM_PLUG_URL}
}

function install_vimconfig(){
    info "install ~/.vimrc..."
    curl -sSL ${VIM_CONFIG_URL} > ~/.vimrc
    info "install ~/.vim_plug..."
    curl -sSL ${VIM_PLUG_CONFIG_URL} > ~/.vim_plug
}

function install_plugins(){
    info "install vim plugins..."
    vim -e -u ~/.vim_plug -i NONE -c "PlugInstall" -c "qa"
}

function info(){
    echo -e "\033[32mINFO: $@\033[0m"
}

function warn(){
    echo -e "\033[33mWARN: $@\033[0m"
}

backup_config
install_plug
install_vimconfig
install_plugins
