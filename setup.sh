#!/usr/bin/env bash
set -eu

CURRENT_DIR=$(cd $(dirname $0); pwd)

cd $CURRENT_DIR

echo "setup..."
for f in dotfiles/.??*
do
    ln -snfv "$f" $HOME/
done