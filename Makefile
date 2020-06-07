INSTALL_DIR=~

.PHONY: install
install: clean update
	git clone https://github.com/gpakosz/.tmux.git ${INSTALL_DIR}/.tmux
	git clone https://github.com/ohmyzsh/ohmyzsh.git ${INSTALL_DIR}/.ohmyzsh

.PHONY: update
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

.PHONY: clean
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
