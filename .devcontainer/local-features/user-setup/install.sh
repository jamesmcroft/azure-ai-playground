#!/usr/bin/env bash

USERNAME=${USERNAME:-"vscode"}

set -eux

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        "$COMMAND"
    fi
}

set_env_variable() {
    VARIABLE_NAME=$1
    VARIABLE_VALUE=$2
    
    sudo_if "echo 'export $VARIABLE_NAME=$VARIABLE_VALUE' >> /etc/bash.bashrc"
}

# Set TESSDATA_PREFIX environment variable
set_env_variable "TESSDATA_PREFIX" "/usr/share/tesseract-ocr/4.00/tessdata"