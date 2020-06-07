INSTALL_DIR=~

.PHONY: install
install: clean update

.PHONY: update
 update: 
	mkdir -p $(INSTALL_DIR)/.config
	cp -r .config/nvim ${INSTALL_DIR}/.config
	cp -r .config/mypy ${INSTALL_DIR}/.config
	cp .pdbrc $(INSTALL_DIR)
	cp .pylintrc $(INSTALL_DIR)
	cp -r .vim $(INSTALL_DIR)
	cp .vimrc $(INSTALL_DIR)
	cp .zshrc $(INSTALL_DIR)
	cp .mrconfig $(INSTALL_DIR)
	cp .gitconfig $(INSTALL_DIR)
	cp .tmux.conf.local $(INSTALL_DIR)
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/gpakosz/.tmux.git ${INSTALL_DIR}/.tmux

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
