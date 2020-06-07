export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$PATH
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

export USE_PYENV=true
export USE_CONDA=false
export PYENV_ROOT=$HOME/.pyenv/
export CONDA_ROOT=$HOME/anaconda3

if [ -d $HOME/.config/zsh ]; then
	for f in $(ls $HOME/.config/zsh/*.zsh); do
		source $f;
	done
fi

# Python env 
# -----------------------------------------------------------------------------
if [ "$USE_CONDA" = true ]; then
    # >>> conda initialize >>>
    __conda_setup="$('""$CONDA_ROOT""'/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
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


# NPM env
#------------------------------------------------------------------------------
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
if [[ -d $HOME/.npm-modules ]]; then
  export PATH=$PATH:$HOME/.npm-modules/bin
fi


# GPU 
# -----------------------------------------------------------------------------
if [[ "`hostname`" == diffrac ]]; then
  export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
  export PATH=$PATH:/usr/local/cuda/bin
else
  export LD_LIBRARY_PATH=/usr/local/cuda/lib:$LD_LIBRARY_PATH
  export PATH=$PATH:/usr/local/cuda/bin
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


# commands
# -----------------------------------------------------------------------------
alias tb="nc termbin.com 9999" 
alias ca="conda activate"
alias pudb="python -m pudb.run "
alias e="nvim"
alias tad="tmux a -d"
alias pdb="python -m pdb -c c"
alias rsync="rsync --info=progress3"

# ros
# -----------------------------------------------------------------------------
if [ -d /opt/ros/melodic/ ]; then
  source /opt/ros/melodic/setup.zsh
  # bugfix on robothoth
  export LD_LIBRARY_PATH=/optlouis/ros/lib:$LD_LIBRARY_PATH
fi
if [ -d ~/ros ]; then
  source $HOME/ros/devel/setup.zsh
fi

# pinocchio
# ---------
if [ -d /opt/openrobots/ ]; then
  export PATH=/opt/openrobots/bin:$PATH 
  export PKG_CONFIG_PATH=/opt/openrobots/lib/pkgconfig:$PKG_CONFIG_PATH
  export LD_LIBRARY_PATH=/opt/openrobots/lib:$LD_LIBRARY_PATH
  export PYTHONPATH=/opt/openrobots/lib/python3.6/site-packages:$PYTHONPATH
fi

# mujoco 
# ------ 
if [ -d $HOME/.mujoco ]; then 
  export LD_LIBRARY_PATH=$HOME/.mujoco/mujoco200/bin:$LD_LIBRARY_PATH
  # See explanations on https://github.com/openai/mujoco-py/pull/145
  export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libGLEW.so:/usr/lib/x86_64-linux-gnu/libGL.so
fi 

# pybullet 
# --------
if [ -d $HOME/src/bullet3/build_cmake/examples/pybullet ]; then
  export PYTHONPATH=$HOME/src/bullet3/build_cmake/examples/pybullet:$PYTHONPATH
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
