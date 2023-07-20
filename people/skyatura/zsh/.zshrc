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
  echo " 🐳($result)"
}
function node_info() {
  version=$(node -v)
  if [[ "$version" == "" ]]; then
    return
  fi
  echo " 📦($version)"
}
NEWLINE=$'\n'
PROMPT='${NEWLINE}%B'
PROMPT+='%F{#888}$(date "+%H:%M:%S")'
PROMPT+=' %F{#0F0}$USER%F{#FF0}@%m'
PROMPT+='%F{#090}$(node_info)'
PROMPT+='%F{#0AA}$(docker_info)'
PROMPT+=' $(git_prompt_info)'
PROMPT+='${NEWLINE}$b'
PROMPT+='%F{cyan}%c %B%(?:%F{green}➜ :%F{red}➜ )%b%f '

# User configuration

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
touch ~/.local/.zshrc ~/.motd
source ~/.local/.zshrc
