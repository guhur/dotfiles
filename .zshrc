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


# ZSH
# -----------------------------------------------------------------------------
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd.mm.yyyy"

plugins=(
  git
  vi-mode
)
source $ZSH/oh-my-zsh.sh
local ret_status="%(?:%{$fg_bold[green]%}%m:%{$fg_bold[red]%}%m)"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fdfind --type f'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


function pfwd {
  for i in ${@:2}
  do
    echo Forwarding port $i
    ssh -n -N -L ${i}:localhost:$i $1
  done  
}
