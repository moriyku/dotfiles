if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Rye
# export PATH="$HOME/.rye/shims:$PATH"
source "$HOME/.rye/env"

# X-Server
export DISPLAY=localhost:0.0

# SSH-Agent
eval `ssh-agent`