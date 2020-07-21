#!/usr/bin/env bash

set -e

OS_TYPE="$(lsb_release -is)"
GITHUB_HOST=${GITHUB_HOST-"github.com"}
PERF_TOOLS_URL="https://${GITHUB_HOST}/brendangregg/perf-tools.git"

function install_perf-tools(){
    info "install perf-tools..."
    git clone --depth 1 ${PERF_TOOLS_URL} /usr/local/perf-tools
    info "perf-tools is installed, you need to add /usr/local/perf-tools/bin to the PATH."
    if [ "${OS_TYPE}" == "Ubuntu" ]; then
        info "On Ubuntu systems, you may also need to install the [linux-tools-common, linux-tools-generic] packages to make perf-tools work."
    fi
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

install_perf-tools
