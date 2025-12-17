#!/bin/zsh

# 対話シェル用 (プロンプト/補完/プラグイン等)

# Homebrew の site-functions を補完候補に追加
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
elif [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
elif [[ -d /usr/local/share/zsh/site-functions ]]; then
  fpath=(/usr/local/share/zsh/site-functions $fpath)
fi

# 補完
autoload -Uz compinit
_zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
command mkdir -p "$_zsh_cache_dir"
compinit -d "$_zsh_cache_dir/zcompdump"

# プロンプト (Pure)
autoload -U promptinit; promptinit
zmodload zsh/nearcolor 2>/dev/null || true
zstyle :prompt:pure:path color '#921499'
zstyle :prompt:pure:git:branch color '#42f58d'
prompt pure

# zsh-autosuggestions
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif command -v brew >/dev/null 2>&1; then
  _zp="$(brew --prefix 2>/dev/null || true)"
  [[ -n "$_zp" && -f "$_zp/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "$_zp/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  unset _zp
fi

# zsh-syntax-highlighting (最後に読み込むのが推奨)
if [[ -n "${HOMEBREW_PREFIX:-}" && -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif command -v brew >/dev/null 2>&1; then
  _zp="$(brew --prefix 2>/dev/null || true)"
  [[ -n "$_zp" && -f "$_zp/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$_zp/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  unset _zp
fi

# fzf (brewインストール時のみ有効化)
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
  [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
fi

# SSH越しだけ keychain をアンロック（初回だけ）
if [[ -n "${SSH_CONNECTION:-}" && -z "${KEYCHAIN_UNLOCKED:-}" ]]; then
  security unlock-keychain "$HOME/Library/Keychains/login.keychain-db" 2>/dev/null || true
  export KEYCHAIN_UNLOCKED=true
fi
