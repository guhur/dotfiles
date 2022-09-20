# Configuration of my self-hosted server


Machine is running on Ubuntu 20.04.

## Installation

```bash
sudo apt install make
mkdir src
git clone https://github.com/guhur/dotfiles
cd dotfiles
make docker

# Optional (config files)
make install
make ripgrep
make neovim
sudo apt install libfuse-dev
```

