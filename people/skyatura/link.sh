#!/usr/bin/env zsh

DOTSKY="$(pwd)"

cd "$HOME"

function link() {
  source="$DOTSKY/$1" 
  target="$HOME/$2" 
  if [[ -f "$target" || -d "$target" ]]; then
    print -P "%F{green}$source -> $target already linked%f"
  else
    ln -s "$source" "$target" && print -P "%F{yellow}$source -> $target linked%f"
  fi
}

function linkw() {
  for file in $(cd "$DOTSKY" && find $@ -type f); do
    link "$file" ".local/bin/$(basename $file)"
  done
}

mkdir -p .local/bin .config

link "zsh/.zshrc" ".zshrc"
link "zsh/.zshenv" ".zshenv"
link "zsh/.zprofile" ".zprofile"
link "local/zsh/.zshrc" ".local/.zshrc"

linkw "bin" "local/bin"

link "kitty" ".config/kitty"
link "lvim" ".config/lvim"
link "neofetch" ".config/neofetch"

link "local/.ssh/config" ".ssh/config"

link "hammerspoon" ".hammerspoon"
