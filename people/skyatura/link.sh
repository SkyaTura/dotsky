#!/usr/bin/env zsh

DOTSKY="$(pwd)"

cd "$HOME"

function link() {
  source="$DOTSKY/$1" 
  target="$HOME/$2" 
  if [[ -f "$target" ]]; then
    ln -s "$source" "$target" && echo "$source -> $target linked"
  else
    echo "$DOTSKY/$1 already linked"
  fi
}

function linkw() {
  source="$DOTSKY/$1"
  target="$HOME/$2" 
  ln -s "$source"/* "$target" && echo "$source -> $target linked"
}

mkdir -p .local/bin .config

link zsh/.zshrc
link zsh/.zshenv
link zsh/.zshprofile
link local/zsh/.zshrc .local/

linkw bin .local/bin/
linkw local/bin .local/bin/

link kitty .config/
link lvim .config/
link neofetch .config/

link hammerspoon .hammerspoon
