#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

backup_path() {
  local path="$1"
  local backup_dir="$HOME/.setup_backup/$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup_dir"
  mv "$path" "$backup_dir/"
  echo "$backup_dir/$(basename "$path")"
}

install_dotfiles() {
  echo "Install dotfiles..."
  shopt -s dotglob nullglob
  for src in "$ROOT_DIR/Dotfiles"/.*; do
    local base
    base="$(basename "$src")"
    [[ "$base" == "." || "$base" == ".." ]] && continue
    local dest="$HOME/$base"

    if [[ -e "$dest" || -L "$dest" ]]; then
      local backed_up
      backed_up="$(backup_path "$dest")"
      echo "  backup: $dest -> $backed_up"
    fi
    cp -a "$src" "$dest"
    echo "  installed: $dest"
  done

  # legacy cleanup: 互換を残さない方針
  if [[ -f "$HOME/.zsh_profile" || -L "$HOME/.zsh_profile" ]]; then
    local backed_up
    backed_up="$(backup_path "$HOME/.zsh_profile")"
    echo "  removed legacy: ~/.zsh_profile (backup: $backed_up)"
  fi
}

install_ssh() {
  if [[ -d "$ROOT_DIR/Dotfiles/.ssh" ]]; then
    echo "Install ~/.ssh..."
    if [[ -e "$HOME/.ssh" || -L "$HOME/.ssh" ]]; then
      local backed_up
      backed_up="$(backup_path "$HOME/.ssh")"
      echo "  backup: ~/.ssh -> $backed_up"
    fi
    cp -a "$ROOT_DIR/Dotfiles/.ssh" "$HOME/.ssh"
  fi

  if [[ -d "$HOME/.ssh" ]]; then
    chmod 700 "$HOME/.ssh" || true
    find "$HOME/.ssh" -type f -name "*.pub" -exec chmod 644 {} \; 2>/dev/null || true
    find "$HOME/.ssh" -type f ! -name "*.pub" -exec chmod 600 {} \; 2>/dev/null || true
  fi
}

ensure_brew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

eval_brew_shellenv() {
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
    return
  fi
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_brew_bundle() {
  echo "Install Homebrew packages..."
  eval_brew_shellenv
  brew tap homebrew/bundle
  brew bundle --file "$ROOT_DIR/Brewfile"
}

import_preferences() {
  echo "Import macOS preferences (defaults)..."
  local pref_dir="$ROOT_DIR/Preferences"

  # Global
  defaults import -globalDomain "$pref_dir/.GlobalPreferences.plist"

  # Others
  shopt -s nullglob
  for plist in "$pref_dir"/*.plist; do
    local file_name domain
    file_name="$(basename "$plist")"
    [[ "$file_name" == ".GlobalPreferences.plist" ]] && continue
    domain="${file_name%.plist}"
    defaults import "$domain" "$plist"
  done

  # 反映
  killall Dock Finder SystemUIServer 2>/dev/null || true
}

sync_xcode_userdata() {
  echo "Sync Xcode UserData..."
  local dir="$HOME/Library/Developer/Xcode/UserData"
  local repo="git@github.com:kyoya1123/XcodeUserData.git"
  mkdir -p "$dir"

  if [[ -d "$dir/.git" ]]; then
    git -C "$dir" pull --rebase
    return
  fi

  if [[ -n "$(ls -A "$dir" 2>/dev/null || true)" ]]; then
    local backed_up
    backed_up="$(backup_path "$dir")"
    echo "  backup: $dir -> $backed_up"
    mkdir -p "$dir"
  fi
  git clone "$repo" "$dir"
}

install_dotfiles
install_ssh
ensure_brew
install_brew_bundle
import_preferences
sync_xcode_userdata
