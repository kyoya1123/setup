
# pure
fpath+=/opt/homebrew/share/zsh/site-functions
autoload -U promptinit; promptinit
zmodload zsh/nearcolor
zstyle :prompt:pure:path color '#921499'
zstyle :prompt:pure:git:branch color '#42f58d'
prompt pure

# autosuggest
source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh

# autocompletion
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

. ~/.zsh_profile
