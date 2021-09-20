INSTALL_DIR=~
LOCAL_DIR=$(INSTALL_DIR)/.local
GITHUB_VERSION = 1.14.0
ZSH_VERSION = 5.8
NODE_VERSION = 16.9.1

all: install update clean nvim
.PHONY: all
	
install: clean update
	git clone https://github.com/gpakosz/.tmux.git ${INSTALL_DIR}/.tmux
	git clone https://github.com/ohmyzsh/ohmyzsh.git ${INSTALL_DIR}/.oh-my-zsh

update: 
	mkdir -p $(INSTALL_DIR)/.config
	ln -sf ${PWD}/.config/nvim ${INSTALL_DIR}/.config
	ln -sf ${PWD}/.config/mypy ${INSTALL_DIR}/.config
	ln -sf ${PWD}/.pdbrc $(INSTALL_DIR)
	ln -sf ${PWD}/.pylintrc $(INSTALL_DIR)
	ln -sf ${PWD}/.vim $(INSTALL_DIR)
	ln -sf ${PWD}/.vimrc $(INSTALL_DIR)
	ln -sf ${PWD}/.zshrc $(INSTALL_DIR)
	ln -sf ${PWD}/.mrconfig $(INSTALL_DIR)
	ln -sf ${PWD}/.gitconfig $(INSTALL_DIR)
	ln -sf ${PWD}/.tmux.conf.local $(INSTALL_DIR)
	ln -sf ${INSTALL_DIR}/.tmux/.tmux.conf  $(INSTALL_DIR)/.tmux.conf

clean:
	rm -rf $(INSTALL_DIR)/.config/nvim
	rm -rf $(INSTALL_DIR)/.config/mypy
	rm -rf $(INSTALL_DIR)/.pdbrc
	rm -rf $(INSTALL_DIR)/.pylintrc
	rm -rf $(INSTALL_DIR)/.vim
	rm -rf $(INSTALL_DIR)/.vimrc
	rm -rf $(INSTALL_DIR)/.zshrc
	rm -rf $(INSTALL_DIR)/.mrconfig
	rm -rf $(INSTALL_DIR)/.gitconfig
	rm -rf $(INSTALL_DIR)/.tmux.conf.local
	rm -rf $(INSTALL_DIR)/.oh-my-zsh
	rm -rf $(INSTALL_DIR)/.tmux

neovim:
	if ! command -v nvim %> /dev/null ; then \
		mkdir -p $(LOCAL_DIR)/bin && \
		wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O $(LOCAL_DIR)/bin/nvim && \
		chmod a+x $(LOCAL_DIR)/bin/nvim; \
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
		wget https://nodejs.org/download/release/latest-v16.x/node-v$(NODE_VERSION)-linux-x64.tar.xz && \
		tar -xf  node-v$(NODE_VERSION)-linux-x64.tar.xz && \
		rsync -arP node-v$(NODE_VERSION)-linux-x64 $(LOCAL_DIR); \
	fi
