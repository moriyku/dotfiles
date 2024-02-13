#!/usr/bin/env bash
set -eu
CURRENT_DIR=$(cd $(dirname $0); pwd)
DOT_DIR=$CURRENT_DIR/home

has() {
  type "$1" > /dev/null 2>&1
}

if ! has sudo; then
    echo "Install sudo..."
    apt install -y sudo
fi

if ! has git; then
    echo "Install git..."
    sudo apt install -y git
fi

if ! has nvm; then
    if ! has curl; then
        echo "curl is not available. Installing curl..."
        sudo apt install curl -y
    fi
    echo "Install nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

cd $DOT_DIR

echo "Setup..."
for f in .??*
do
    echo "Create $f to home directory..."
    cp -aiT "$DOT_DIR/$f" "$HOME/$f"
done
tput setaf 2 && echo "✔ Dotfiles installed successfully!" && tput sgr0