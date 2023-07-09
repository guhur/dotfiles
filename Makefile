OS=linux
ARCH=amd64

INSTALL_DIR=$(shell readlink -f ~)
LOCAL_DIR=$(INSTALL_DIR)/.local
CONFIG_DIR=$(INSTALL_DIR)/.config

GITHUB_VERSION = 2.13.0
ZSH_VERSION = 5.9
TMUX_VERSION = 3.2a
NODE_VERSION = 16.12.0
GO_VERSION=1.17.6
SINGULARITY_VERSION=3.9.4
NEOVIM_VERSION=0.9.1

all: install update clean
.PHONY: all

help :           ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	
install: clean update
	git clone https://github.com/gpakosz/.tmux.git ${INSTALL_DIR}/.tmux
	git clone https://github.com/ohmyzsh/ohmyzsh.git ${INSTALL_DIR}/.oh-my-zsh

update: 
	mkdir -p $(INSTALL_DIR)/.config
	mkdir -p $(LOCAL_DIR)/bin
	ln -sf $(which zsh) $(LOCAL_DIR)/bin/
	ln -sf ${PWD}/.config/nvim ${INSTALL_DIR}/.config
	ln -sf ${PWD}/.config/mypy ${INSTALL_DIR}/.config
	ln -sf ${PWD}/.config/neomutt ${INSTALL_DIR}/.config
	ln -sf ${PWD}/.pdbrc $(INSTALL_DIR)
	ln -sf ${PWD}/.pylintrc $(INSTALL_DIR)
	ln -sf ${PWD}/.vim $(INSTALL_DIR)
	ln -sf ${PWD}/.vimrc $(INSTALL_DIR)
	ln -sf ${PWD}/.zshrc $(INSTALL_DIR)
	ln -sf ${PWD}/.fzf.zsh $(INSTALL_DIR)
	ln -sf ${PWD}/.mrconfig $(INSTALL_DIR)
	ln -sf ${PWD}/.gitconfig $(INSTALL_DIR)
	ln -sf ${PWD}/.screenrc $(INSTALL_DIR)
	ln -sf ${PWD}/.tmux.conf.local $(INSTALL_DIR)
	ln -sf ${INSTALL_DIR}/.tmux/.tmux.conf  $(INSTALL_DIR)/.tmux.conf
	for f in $(ls $(PWD)/scripts/); do ln -sf $(PWD)/scripts/$f $(LOCAL_DIR)/bin/$f; done

clean:
	rm -rf $(INSTALL_DIR)/.config/nvim
	rm -rf $(INSTALL_DIR)/.config/mypy
	rm -f $(INSTALL_DIR)/.pdbrc
	rm -f $(INSTALL_DIR)/.pylintrc
	rm -f $(INSTALL_DIR)/.vim
	rm -f $(INSTALL_DIR)/.vimrc
	rm -f $(INSTALL_DIR)/.zshrc
	rm -f ${INSTALL_DIR}/.fzf.zsh 
	rm -f $(INSTALL_DIR)/.mrconfig
	rm -f $(INSTALL_DIR)/.gitconfig
	rm -f $(INSTALL_DIR)/.tmux.conf.local
	rm -rf $(INSTALL_DIR)/.oh-my-zsh
	rm -rf $(INSTALL_DIR)/.tmux

neovim:
	if ! command -v nvim %> /dev/null ; then \
		mkdir -p $(LOCAL_DIR)/bin && \
		wget https://github.com/neovim/neovim/releases/download/v$(NEOVIM_VERSION)/nvim.appimage -O $(LOCAL_DIR)/bin/nvim && \
		chmod a+x $(LOCAL_DIR)/bin/nvim; \
	fi

tmux:
	if ! command -v tmux %> /dev/null ; then \
		mkdir -p $(LOCAL_DIR)/bin && \
		wget https://github.com/nelsonenzo/tmux-appimage/releases/download/$(TMUX_VERSION)/tmux.appimage -O $(LOCAL_DIR)/bin/tmux && \
		chmod a+x $(LOCAL_DIR)/bin/tmux; \
	fi

gh:
	if ! command -v gh %> /dev/null ; then \
		mkdir -p $(LOCAL_DIR)/bin && \
		wget https://github.com/cli/cli/releases/download/v$(GITHUB_VERSION)/gh_$(GITHUB_VERSION)_linux_amd64.tar.gz -O gh.tar.gz && \
			tar -xzvf gh.tar.gz  && \
			rsync -ar gh_$(GITHUB_VERSION)_linux_amd64/ $(LOCAL_DIR) && \
			chmod a+x $(LOCAL_DIR)/bin/gh; \
	fi


zsh:
	if ! command -v zsh %> /dev/null ; then \
		wget https://github.com/zsh-users/zsh/archive/refs/tags/zsh-$(ZSH_VERSION).tar.gz && \
		tar -xzvf zsh-$(ZSH_VERSION).tar.gz && \
		cd zsh-zsh-$(ZSH_VERSION) && \
		./Util/preconfig && \
		./configure --prefix=$(LOCAL_DIR) && \
		make -j 5 && \
		make install && \
		rm zsh-zsh-$(ZSH_VERSION); \
	fi

npm:
	if ! command -v npm %> /dev/null ; then \
		$(shell curl -qL https://www.npmjs.com/install.sh | sh); \
	fi

node:
	if ! command -v node %> /dev/null; then \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
		NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist nvm install node; \
	fi

powerline:
	wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf --no-check-certificate && \
	mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/ && \
	fc-cache -vf ~/.fonts && \
	mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/


miniconda:
	wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
	zsh ~/miniconda.sh -b -p ~/miniconda && \
	rm ~/miniconda.sh && \
	export PATH=~/miniconda/bin:${PATH}

ripgrep:
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz && \
	tar -xzvf ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz  && \
	mv ripgrep-13.0.0-x86_64-unknown-linux-musl/rg $(LOCAL_DIR)/bin && \
	rm -r ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz ripgrep-13.0.0-x86_64-unknown-linux-musl

docker:
	curl -fsSL https://get.docker.com -o get-docker.sh && \
	chmod a+x get-docker.sh && \
	./get-docker.sh && \
	sudo groupadd docker && \
	sudo usermod -aG docker $(bash whoami) && \
	newgrp docker
	

fzf:
	sudo apt-get install fzf

brew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
	mkdir -vp $(CONFIG_DIR)/zsh && \
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $(CONFIG_DIR)/zsh/mac.zsh && \
	source $(CONFIG_DIR)/zsh/mac.zsh

