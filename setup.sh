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

# diff-highlight
if [ ! -L /usr/local/bin/diff-highlight ]; then
    print_begin "Install diff-highlight..."
    sudo chmod 755 /usr/share/doc/git/contrib/diff-highlight/diff-highlight
    sudo ln -s /usr/share/doc/git/contrib/diff-highlight/diff-highlight /usr/local/bin/diff-highlight
    print_success "diff-highlight installed."
fi

# Install nkf
if ! has nkf; then
    print_begin "Install nkf..."
    sudo apt install -y nkf
    print_success "nkf installed."
fi

# Install curl
if ! has curl; then
    print_begin "curl is not available. Installing curl..."
    sudo apt install curl -y
    print_success "curl installed."
fi

# Install uv
if ! has uv; then
    print_begin "Install uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Shell autocompletion
    echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc
    echo 'eval "$(uvx --generate-shell-completion bash)"' >> ~/.bashrc
    print_success "uv installed."
fi

# Load nvm if it is already installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install nvm
if ! has nvm; then
    print_begin "Install nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    print_success "nvm installed."

    print_begin "Install Node.js..."
    nvm install --lts
    print_success "Node.js installed."
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