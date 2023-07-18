# Language environment
export LANG="pt_BR.UTF-8"
export LC_COLLATE="pt_BR.UTF-8"
export LC_CTYPE="pt_BR.UTF-8"
export LC_MESSAGES="pt_BR.UTF-8"
export LC_MONETARY="pt_BR.UTF-8"
export LC_NUMERIC="pt_BR.UTF-8"
export LC_TIME="pt_BR.UTF-8"
export LC_ALL="pt_BR.UTF-8"

# Load homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Load fnm
eval "$(fnm env --use-on-cd)"
