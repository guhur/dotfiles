OS=linux
ARCH=amd64

INSTALL_DIR=~
LOCAL_DIR=$(INSTALL_DIR)/.local

GITHUB_VERSION = 1.14.0
ZSH_VERSION = 5.8
TMUX_VERSION = 3.2a
NODE_VERSION = 16.12.0
GO_VERSION=1.17.6
SINGULARITY_VERSION=3.9.4
NEOVIM_VERSION=0.7.0

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
		wget https://github.com/nelsonenzo/tmux-appimage/releases/download/v$(TMUX_VERSION)/tmux.appimage -O $(LOCAL_DIR)/bin/tmux && \
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
		./configure --prefix=$(LOCAL_DIR)/.local && \
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
		curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh -O nvm.sh && \
		./nvm.sh && \
		rm nvm.sh && \
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

pv:
	wget https://anaconda.org/conda-forge/pv/1.6.6/download/linux-64/pv-1.6.6-h470a237_0.tar.bz2
	mkdir pv
	tar -xvf pv-1.6.6-h470a237_0.tar.bz2 -C pv
	mv pv/bin/pv $(LOCAL_DIR)/bin/
	rsync -r pv/share/ $(LOCAL_DIR)/share/

singularity:
	# sudo apt-get update && sudo apt-get install -y \
	#     build-essential \
	#     libssl-dev \
	#     uuid-dev \
	#     libgpgme11-dev \
	#     squashfs-tools \
	#     libseccomp-dev \
	#     wget \
	#     pkg-config \
	#     git
	wget https://dl.google.com/go/go$(GO_VERSION).$(OS)-$(ARCH).tar.gz --no-check-certificate
	tar -xzvf go$(GO_VERSION).$(OS)-$(ARCH).tar.gz
	rsync -r go/ $(LOCAL_DIR)
	rm -r go$(GO_VERSION).$(OS)-$(ARCH).tar.gz go/
	wget https://github.com/sylabs/singularity/releases/download/v${SINGULARITY_VERSION}/singularity-ce_${SINGULARITY_VERSION}-bionic_$(ARCH).deb --no-check-certificate
	sudo dpkg -i singularity-ce_${SINGULARITY_VERSION}-bionic_amd64.deb

neomutt:
	sudo apt-get install -y neomutt
