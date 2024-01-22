# oh-my-zsh minimal is only relevant in interactive terminals
[[ "$-" == *i* ]] || return

# If ZSH is not defined, use the current script's directory.
[[ -z "$ZSH" ]] && export ZSH="${${(%):-%x}:a:h}"

# Set ZSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$HOME/.zsh_cache"
fi

# Create cache and completions dir and add to $fpath
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit zrecompile

# source a file in a local variable context
_omz_source() {
  source "$1"
}

# Load all of the lib files in ~/oh-my-zsh/lib that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for file ("$ZSH"/lib/*.zsh); do
  _omz_source "$file"
done
unset file

# Load all of the plugins. To manage plugins, drop them in plugin dir
for file ("$ZSH"/plugins/*/*.plugin.zsh); do
  _omz_source "$file"
done
unset file

if [[ -n "$ZSH_THEME" ]]; then
  source "$ZSH/themes/$ZSH_THEME.zsh-theme"
fi

# set completion colors to be the same as `ls`, after theme has been loaded
[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
