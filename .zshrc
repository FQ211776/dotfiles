# -- INIT ----------------------------------------------------------------------

# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# -- SETTINGS -----------------------------------------------------------------

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k"
# Install missing plugins (assuming you use Oh My Zsh)


plugins=(git aliases archlinux branch github  zsh-interactive-cd zsh-navigation-tools)
source $ZSH/oh-my-zsh.sh

# -- ZINIT ---------------------------------------------------------------------

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit



# -- PLUGINS -------------------------------------------------------------------

zinit ice depth=1
zinit light Aloxaf/fzf-tab
# zinit light romkatv/powerlevel10k

zinit wait lucid light-mode for \
ver="dev" \
atload'bindkey "^u" dotbare-transform;
bindkey "^d" dotbare-fedit' \
kazhala/dotbare \
kazhala/bmux \
kazhala/dump-cli \
aubreypwd/zsh-plugin-reload \
https://github.com/kazhala/scripts/blob/master/shell/fbookmark \
https://raw.githubusercontent.com/aws/aws-cli/develop/bin/aws_zsh_completer.sh \
atload'bindkey -M vicmd "k" history-substring-search-up;
bindkey -M vicmd "j" history-substring-search-down' \
zsh-users/zsh-history-substring-search \
atload'_zsh_autosuggest_start;
unset ZSH_AUTOSUGGEST_USE_ASYNC;
bindkey -v "^ " autosuggest-accept' \
zsh-users/zsh-autosuggestions \
atinit'ZINIT[COMPINIT_OPTS]=-C;
zicompinit;
zicdreplay;
_dotbare_completion_cmd;
complete -o nospace -C "$(which terraform)" terraform;
eval "$(register-python-argcomplete pipx)"' \
  atload"FAST_HIGHLIGHT[chroma-man]=" \
    zdharma-continuum/fast-syntax-highlighting




source ~/.zshrc_aliases
source ~/.zshrc_functions
source ~/.zshrc_path_exports
source /usr/share/zsh/plugins/forgit/forgit.plugin.zsh
source ~/.git-flow-completion.zsh

if command -v zoxide > /dev/null; then
  eval "$(zoxide init bash)"
fi



# -- KEYBINDING ----------------------------------------------------------------

zle -N fm-invoke _run_fm
bindkey "^g" fm-invoke

zle -N ffd-d-invoke _run_ffd_d
bindkey "\ed" ffd-d-invoke

# -- BMUX ----------------------------------------------------------------------

export BMUX_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bmux"
export BMUX_ACTIVE_SYMBOL=""
export BMUX_INACTIVE_SYMBOL=""
export BMUX_ACTIVE_COLOR="32"
export BMUX_TREE_SYMBOL="﬌"

export BMUX_3_WEB='05c6,210x63,0,0{150x63,0,0,56,59x63,151,0[59x31,151,0,57,59x31,151,32,58]}'
export BMUX_3_VS='3807,210x63,0,0[210x45,0,0,1,210x17,0,46{105x17,0,46,3,104x17,106,46,4}]'
export BMUX_CODE='578a,239x62,0,0[239x45,0,0,30,239x16,0,46,31]'

# -- DUMP ----------------------------------------------------------------------

export DUMP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dump/trash"
export DUMP_LOG="${XDG_DATA_HOME:-$HOME/.local/share}/dump/log"

# -- LESS ----------------------------------------------------------------------

export LESSHISTFILE=-
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# -- DOTBARE -------------------------------------------------------------------

export DOTBARE_DIR="$HOME/.cfg/"
export DOTBARE_TREE="$HOME"
export DOTBARE_BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/dotbare"
export DOTBARE_FZF_DEFAULT_OPTS="--preview-window=right:65%"
export DOTBARE_DIFF_PAGER="delta --diff-so-fancy --line-numbers"
export DOTBARE_KEY="
  --bind=alt-a:toggle-all
  --bind=alt-w:jump
  --bind=alt-0:top
  --bind=alt-s:toggle-sort
  --bind=alt-t:toggle-preview
"

# -- FZF ----------------------------------------------------------------------

_gen_fzf_default_opts() {
local color00='#2E3440'
local color01='#3B4252'
local color02='#434C5E'
local color03='#4C566A'
local color04='#D8DEE9'
local color05='#E5E9F0'
local color06='#ECEFF4'
local color07='#8FBCBB'
local color08='#BF616A'
local color09='#D08770'
local color0A='#EBCB8B'
local color0B='#A3BE8C'
local color0C='#88C0D0'
local color0D='#81A1C1'
local color0E='#B48EAD'
local color0F='#5E81AC'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --color=bg+:$color00,bg:$color00,spinner:$color0C,hl:$color0D
  --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
  --height 100% --layout=reverse --border --cycle --info=inline
  --bind=ctrl-d:preview-page-down
  --bind=ctrl-u:preview-page-up
"
}

_gen_fzf_default_opts

export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_ALT_C_OPTS="--preview 'tree -L 1 -C --dirsfirst {} | head -200'"

# Use fd to generate auto completion
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# activate fzf keybindings
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
export FZF_COMPLETION_TRIGGER=''
export FZF_PREVIEW_COMMAND='cat {}'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

[ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ] && source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh
# Source the Lazyman shell initialization for aliases and nvims selector
# shellcheck source=.config/nvim-Lazyman/.lazymanrc
[ -f ~/.config/nvim-Lazyman/.lazymanrc ] && source ~/.config/nvim-Lazyman/.lazymanrc
# Source the Lazyman .nvimsbind for nvims key binding
# shellcheck source=.config/nvim-Lazyman/.nvimsbind
[ -f ~/.config/nvim-Lazyman/.nvimsbind ] && source ~/.config/nvim-Lazyman/.nvimsbind
# Luarocks bin path
[ -d ${HOME}/.luarocks/bin ] && {
  export PATH="${HOME}/.luarocks/bin${PATH:+:${PATH}}"
}
# Bob neovim version manager path
[ -d ${HOME}/.local/share/bob/nvim-bin ] && {
  export PATH="${HOME}/.local/share/bob/nvim-bin${PATH:+:${PATH}}"
}

# zsh example
bindkey -s '^a' "dotbare fedit"^


zle -N fm-invoke _run_fm
bindkey "^g" fm-invoke

zle -N ffd-d-invoke _run_ffd_d
bindkey "\ed" ffd-d-invoke

source <(jj util completion zsh)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
 eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/RobertoFlores.omp.json)"
# eval "$(starship init zsh)"
