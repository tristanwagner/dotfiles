# Uncomment that for profiling Initialization
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="agnosterzak"
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# auto nvm use when .nvmrc
export NVM_AUTO_USE=true

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-z fzf history-substring-search zsh-vi-mode zsh-autosuggestions forgit zsh-nvm zsh-syntax-highlighting zsh-you-should-use zsh-bat)
#plugins+=(zsh-nvm history-substring-search vi-mode)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history  # Share history across terminals
setopt inc_append_history  # Save commands to history immediately

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export VISUAL='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# make fzf use rg instead of default command
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
ZSH_DISABLE_COMPFIX='true'
source $ZSH/oh-my-zsh.sh

if command -v fzf &>/dev/null; then
  # Don't source FZF shell integrations if version is older than 0.48 (Avoids `unknown option: --bash`)
  # Version comparison technique courtesy of Luciano Andress Martini:
  # https://unix.stackexchange.com/questions/285924/how-to-compare-a-programs-version-in-a-shell-script
  FZF_VERSION="$(fzf --version | cut -d' ' -f1)"
  if [[ -f ~/.fzf.zsh && "$(printf '%s\n' 0.48 "$FZF_VERSION" | sort -V | head -n1)" = 0.48 ]]; then
    source ~/.fzf.zsh
  fi
fi

source ~/.aliases

source ~/.utilities.zsh
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true

export PYENV_ROOT="$HOME/.pyenv"
export ANDROID_HOME=/Users/$USER/Library/Android/sdk

# add utils to path
export PATH=$HOME/.gem/ruby/2.6.0/bin:/opt/homebrew/bin:/opt/local/bin:$HOME/.local/bin:$HOME/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH

# android
export PATH=:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools/:$ANDROID_HOME/emulator/:$PATH

# pyenv
if command -v pyenv &>/dev/null; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# ghcup-env
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# define bat theme
export BAT_THEME="gruvbox-dark"

# allow dotfiles while tabbing
setopt globdots

# useful zsh keybinds
# Ctrl + U – delete from the cursor to the start of the line.
# Ctrl + K – delete from the cursor to the end of the line.
# Ctrl + W – delete from the cursor to the start of the preceding word.
# Alt + D – delete from the cursor to the end of the next word.
# Ctrl + L – clear the terminal.
# Ctrl + T – search file
# Ctrl + R – search history
# Ctrl + SHIFT + F – search buffer
# debug zsh loading time
# zmodload zsh/zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if command -v thefuck &>/dev/null; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval $(thefuck --alias f)
fi

# Uncomment that for profiling Initialization
# zprof
# neofetch

# pnpm
export PNPM_HOME="/Users/tristan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
