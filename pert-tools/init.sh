#!/usr/bin/env bash

set -e

GITHUB_HOST=${GITHUB_HOST-"github.com"}
PERF_TOOLS_URL="https://${GITHUB_HOST}/brendangregg/perf-tools.git"

function install_perf-tools(){
    info "install perf-tools..."
    git clone --depth 1 ${PERF_TOOLS_URL} /usr/local/perf-tools
    info "perf-tools is installed, you may need to add /usr/local/perf-tools to the PATH."
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
