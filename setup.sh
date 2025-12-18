#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SUDO_KEEPALIVE_PID=""

cleanup_sudo_keepalive() {
  if [[ -n "${SUDO_KEEPALIVE_PID:-}" ]]; then
    kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
  fi
}

ensure_sudo() {
  if ! command -v sudo >/dev/null 2>&1; then
    return
  fi

  if [[ -n "${SUDO_KEEPALIVE_PID:-}" ]] && kill -0 "$SUDO_KEEPALIVE_PID" 2>/dev/null; then
    sudo -v
    return
  fi

  echo "Ensure sudo session..."
  sudo -v

  # Keep sudo alive while this script is running (avoid repeated password prompts).
  (
    while true; do
      sudo -n -v 2>/dev/null || true
      sleep 30
    done
  ) &
  SUDO_KEEPALIVE_PID=$!
  trap cleanup_sudo_keepalive EXIT
}

install_dotfiles() {
  echo "Install dotfiles..."
  shopt -s dotglob nullglob
  for src in "$ROOT_DIR/Dotfiles"/.*; do
    local base
    base="$(basename "$src")"
    [[ "$base" == "." || "$base" == ".." ]] && continue
    [[ "$base" == ".ssh" ]] && continue
    local dest="$HOME/$base"

    if [[ -e "$dest" || -L "$dest" ]]; then
      rm -rf "$dest"
    fi
    cp -a "$src" "$dest"
    echo "  installed: $dest"
  done

  if [[ -f "$HOME/.zsh_profile" || -L "$HOME/.zsh_profile" ]]; then
    rm -f "$HOME/.zsh_profile"
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
  ensure_sudo
  eval_brew_shellenv
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
    # 強制同期: origin/main に完全に合わせる（ローカル変更は破棄）
    if git -C "$dir" remote get-url origin >/dev/null 2>&1; then
      git -C "$dir" remote set-url origin "$repo" >/dev/null 2>&1 || true
    else
      git -C "$dir" remote add origin "$repo"
    fi
    git -C "$dir" fetch --prune origin
    git -C "$dir" checkout -B main
    git -C "$dir" reset --hard origin/main
    git -C "$dir" clean -fd
    return
  fi

  if [[ -n "$(ls -A "$dir" 2>/dev/null || true)" ]]; then
    rm -rf "$dir"
    mkdir -p "$dir"
  fi
  git clone "$repo" "$dir"
  git -C "$dir" fetch --prune origin
  git -C "$dir" checkout -B main
  git -C "$dir" reset --hard origin/main
  git -C "$dir" clean -fd
}

install_dotfiles
ensure_sudo
ensure_brew
install_brew_bundle
import_preferences
sync_xcode_userdata
