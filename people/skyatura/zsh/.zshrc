# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"

export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

ZSH_THEME="robbyrussell"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto      # update automatically without asking

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  aliases
  brew
  common-aliases
  git
  sudo
  z
)

source $ZSH/oh-my-zsh.sh

function docker_info() {
  result=''
  if [[ -n $DOCKER_HOST ]]; then
    result=$(echo $DOCKER_HOST | sed 's/ssh\:\/\///')
  else
    result='local'
  fi
  echo "🐳($result)"
}
NEWLINE=$'\n'
PROMPT='${NEWLINE}$fg[green]%}$USER%{$fg[yellow]%}@%m  %{$fg[cyan]%}$(docker_info) $(git_prompt_info)${NEWLINE}'
PROMPT+='%{$fg[cyan]%}%c %(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%} '

# User configuration

# You may need to manually set your language environment
export LANG="pt_BR.UTF-8"
export LC_COLLATE="pt_BR.UTF-8"
export LC_CTYPE="pt_BR.UTF-8"
export LC_MESSAGES="pt_BR.UTF-8"
export LC_MONETARY="pt_BR.UTF-8"
export LC_NUMERIC="pt_BR.UTF-8"
export LC_TIME="pt_BR.UTF-8"
export LC_ALL="pt_BR.UTF-8"

export EDITOR='lvim'
alias v="$EDITOR"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshrc="v ~/.zshrc"
alias zshrcl="v ~/.local/.zshrc"
alias ohmyzsh="v ~/.oh-my-zsh"

alias l="ls -lah"

alias s="kitty +kitten ssh"
alias icat="kitty +kitten icat"

alias ni='npm install'
alias nif='npm install --force'
alias nil='npm install --legacy-peer-deps'
alias nrn='rm -rf node_modules'
alias nri='nrn && ni'
alias nis='ni --save'
alias nid='ni --save-dev'
alias nifs='nif --save'
alias nifd='nif --save-dev'
alias nils='nil --save'
alias nild='nil --save-dev'
alias nig='ni -g'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrs='npm start'
alias nrt='npm run test'

gac() {
  git add $@
  gitmoji -c
  git push
}

mkdir -p ~/.local
touch ~/.local/zshrc
source ~/.local/zshrc
