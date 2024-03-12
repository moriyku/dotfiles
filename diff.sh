#!/usr/bin/env bash
set -eu
CURRENT_DIR=$(cd $(dirname $0); pwd)
DOT_DIR=$CURRENT_DIR/home

ls -A "$DOT_DIR" | xargs -t -I{} diff "$DOT_DIR/{}" "$HOME/{}"