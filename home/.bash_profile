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
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# X-Server
export DISPLAY=localhost:0.0

# Composer
export PATH="$PATH:$HOME/.config/composer/vendor/bin"

# pipenv
export PIPENV_VENV_IN_PROJECT=true

# SSH-Agent
eval `ssh-agent`