set -eux

# Setup STDERR.
err() {
    echo "(!) $*" >&2
}

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

###########################################
# Helper Functions
###########################################

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

pip_get_update() {
    echo "Running pip update..."
    pip install --upgrade pip
}

# Checks if apt packages are installed and installs them if not
install_apt_packages() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

# Checks if pip packages are installed and installs them if not
install_pip_packages() {
    if ! pip show "$@" >/dev/null 2>&1; then
        pip_get_update
        pip install "$@"
    fi
}

###########################################
# Install Feature
###########################################

# Install dependencies
install_apt_packages poppler-utils tesseract-ocr libtesseract-dev ffmpeg libsm6 libxext6 software-properties-common python3-dev python3-pip python3-opencv python3-wheel python3-setuptools
install_pip_packages packaging matplotlib transformers pillow torch
install_pip_packages flash_attn timm einops

echo 'dev-tools script has completed!'
