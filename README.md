# Configuration of Mieux Voter server


Machine is running on Ubuntu 22.04.

## Installation

```bash
sudo apt install make
mkdir src
git clone https://github.com/MieuxVoter/dotfiles
cd dotfiles
make docker

# Optional (config files)
make install
make ripgrep
make neovim
sudo apt install libfuse-dev
```

## Launching SWAG server

SWAG = Docker + nginx + let's encrypt + fail2ban + plenty of configuration files.


```bash
cd swag

```
