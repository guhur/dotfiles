# Source global definitions
# if [ -f /etc/bashrc ]; then
# 	. /etc/bashrc
# fi

export PATH=$PATH:$HOME/.local/bin
export LD_LIBRARY_PATH=$HOME/.local/lib64:$HOME/.local/lib:$LD_LIBRARY_PATH

if [ -x "$(command -v nvim)" ]; then
	export VISUAL=nvim
else	
	export VISUAL=vim
fi
export EDITOR="$VISUAL"
export NALANBOT=~/src/nalanbot
export SCRATCH=/scratch/$(hostname)
export DATASETS=$SCRATCH/datasets
export DATASET=$DATASETS
export RESULTS=$SCRATCH/results
export EDGAR_SCRATCH=/scratch/gpuhost6/pguhur/
export COOPER_SCRATCH=/scratch/hdd/
export DIFFRAC_SCRATCH=/scratch/diffrac/
export JEANZAY_HOME=/gpfsssd/scratch/rech/vuo/uok79zh/
export JEANZAY_SCRATCH=/gpfsscratch/rech/vuo/uok79zh

export USE_PYENV=false
export USE_CONDA=false
export PYENV_ROOT=$HOME/.pyenv/
export CONDA_ROOT=$HOME/anaconda3

# commands
# -----------------------------------------------------------------------------
alias tb="nc termbin.com 9999" 
alias ca="conda activate"
alias pudb="python -m pudb.run "
alias e="nvim"
alias tad="tmux a -d"
alias pdb="python -m pdb -c c"
# alias rsync="rsync --info=progress3"
alias rscp='rsync -aP'
alias rsmv='rsync -aP --remove-source-files'
transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n  transfer <file|directory>\n  ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}

# specific config
# -----------------------------------------------------------------------------
if [ -d $HOME/.config/zsh ]; then
	for f in $(ls $HOME/.config/zsh/*.zsh); do
		source $f;
	done
fi

# Python env 
# -----------------------------------------------------------------------------

if [ "$USE_CONDA" = true ]; then
    # >>> conda initialize >>>
    __conda_setup="$('""$CONDA_ROOT""/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
	   . "$CONDA_ROOT/etc/profile.d/conda.sh"
        else
            export PATH="$CONDA_ROOT/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi

if [ "$USE_PYENV" = true ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi


# ZSH - Minimal Configuration (no Oh My Zsh)
# -----------------------------------------------------------------------------

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY             # Share history between all sessions
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file

# Directory navigation
setopt AUTO_CD                   # cd by typing directory name
setopt AUTO_PUSHD                # Push directory onto stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicates
setopt PUSHD_SILENT              # Don't print directory stack

# Completion system - only rebuild cache once per day
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Vi mode
bindkey -v
export KEYTIMEOUT=1              # Reduce delay when switching modes

# Better vi mode keybindings
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Colors
autoload -U colors && colors

# Git prompt function (minimal replacement for oh-my-zsh git plugin)
git_prompt_info() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
    local dirty=""
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        dirty="%{$fg[yellow]%}✗"
    fi
    echo "%{$fg_bold[blue]%}git:(%{$fg[red]%}${branch}%{$fg_bold[blue]%})%{$reset_color%}${dirty} "
}

# Use Starship if available, otherwise use custom prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    # Custom prompt similar to robbyrussell
    setopt PROMPT_SUBST
    local ret_status="%(?:%{$fg_bold[green]%}%m:%{$fg_bold[red]%}%m)"
    PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
fi

# Git aliases (from oh-my-zsh git plugin - most common ones)
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit -v'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias glog='git log --oneline --decorate --graph'
alias gp='git push'
alias gst='git status'
alias gsw='git switch'



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fdfind --type f'

# NVM - Lazy loading for faster shell startup
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # Add node to PATH without loading nvm (use default version)
    [ -d "$NVM_DIR/versions/node" ] && PATH="$NVM_DIR/versions/node/$(ls -1 $NVM_DIR/versions/node | tail -1)/bin:$PATH"

    # Lazy load nvm when first called
    nvm() {
        unset -f nvm node npm npx
        \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
    }
    node() { unset -f nvm node npm npx; \. "$NVM_DIR/nvm.sh"; node "$@"; }
    npm() { unset -f nvm node npm npx; \. "$NVM_DIR/nvm.sh"; npm "$@"; }
    npx() { unset -f nvm node npm npx; \. "$NVM_DIR/nvm.sh"; npx "$@"; }
fi


function pfwd {
  for i in ${@:2}
  do
    echo Forwarding port $i
    ssh -n -N -L ${i}:localhost:$i $1
  done  
}

alias gcma="git commit -am"

# Scaleway CLI autocomplete (without extra compinit call)
if command -v scw &> /dev/null; then
    eval "$(scw autocomplete script shell=zsh | grep -v 'compinit')"
fi

# SDKMAN - Lazy loading
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    sdk() {
        unset -f sdk
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
        sdk "$@"
    }
fi
