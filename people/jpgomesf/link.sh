#!/usr/bin/env zsh

export DOTSKY="$(pwd)"

function link() {
  cd "$HOME"

  source="$DOTSKY/$1" 
  target="$HOME/$2" 
  if [[ -f "$target" || -d "$target" ]]; then
    print -P "%F{green}$source -> $target already linked%f"
  else
    ln -s "$source" "$target" && print -P "%F{yellow}$source -> $target linked%f"
  fi
}

mkdir -p .local/bin .config .k_sessions

function linkw() {
  target=$(basename "$2")
  link "$2" "$1/$target"
}
export _link="$(which linkw); $(which link)"

find "bin" "local/bin" -type f -exec zsh -c "$_link; linkw '.local/bin' '{}'" \;
find "k_sessions" "local/k_sessions" -type f -exec zsh -c "$_link; linkw '.k_sessions' '{}'" \;

link "zsh/.zshrc" ".zshrc"
link "zsh/.zshenv" ".zshenv"
link "zsh/.zprofile" ".zprofile"
link "local/zsh/.zshrc" ".local/.zshrc"

link "kitty" ".config/kitty"
link "lvim" ".config/lvim"
link "neofetch" ".config/neofetch"

link "local/.ssh/config" ".ssh/config"

link "hammerspoon" ".hammerspoon"
