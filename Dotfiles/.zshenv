#!/bin/zsh

# 非対話シェル含めて毎回読み込まれるので「軽い設定」だけ置く
export EDITOR="${EDITOR:-/usr/bin/nano}"

# XDG base directory (なくても動くが、キャッシュ/設定の置き場を安定させる)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

