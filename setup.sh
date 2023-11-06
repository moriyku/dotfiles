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

cd $DOT_DIR

echo "Setup..."
for f in .??*
do
    ln -snfv "$DOT_DIR/$f" "$HOME/$f"
done
tput setaf 2 && echo "✔ Dotfiles installed successfully!" && tput sgr0