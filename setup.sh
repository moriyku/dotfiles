#!/usr/bin/env bash
set -eu
CURRENT_DIR=$(cd $(dirname $0); pwd)
DOT_DIR=$CURRENT_DIR/home

has() {
  type "$1" > /dev/null 2>&1
}

print_begin() {
    echo -e "\n▶️ $1"
}

print_success() {
    tput setaf 2
    echo "✅ $1"
    tput sgr0
}

# Install sudo
if ! has sudo; then
    print_begin "Install sudo..."
    apt install -y sudo
    print_success "sudo installed."
fi

# Install git
if ! has git; then
    print_begin "Install git..."
    sudo apt install -y git
    print_success "git installed."
fi

# Install nvm
if ! has nvm; then
    if ! has curl; then
        print_begin "curl is not available. Installing curl..."
        sudo apt install curl -y
        print_success "curl installed."
    fi
    print_begin "Install nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    print_success "nvm installed."
fi

# Copy dotfiles to home directory
cd $DOT_DIR
print_begin "Copying dotfiles to home directory..."
for f in .??*
do
    print_begin "Create $f to home directory..."
    cp -aiT "$DOT_DIR/$f" "$HOME/$f"
done
print_success "Dotfiles installed successfully!"