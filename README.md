# dotfiles

Dotfiles for macOS and Linux(Ubuntu).

Managed by [dotbot](https://github.com/anishathalye/dotbot).

## Installation

### Pre-Install

```bash
# macOS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  # install homebrew
brew install vim git tmux zsh reattach-to-user-namespace
```

```bash
# Linux
sudo apt update
sudo apt install vim git tmux zsh ripgrep
```

### Dotfiles Install

```bash
# First time install
git clone --depth 1 https://github.com/ShangjinTang/dotfiles ~/.dotfiles && ~/.dotfiles/install

# Update (if some errors are occured after update, sometimes need to manually remove old symlinks in $HOME directory)
git pull && ~/.dotfiles/install
```

### Post-Install


```bash
# fzf installation (select Y,Y,N respectively)
~/.fzf/install
# install vim plugins
vim +PlugInstall
```

---

## dotfiles customization

1. Add configuration files.
2. Edit `preinstall` to create flags to dynamic control fuctions (platform-independent) toggle on or off.
3. Edit `install.conf.yaml` to create symlink.

---

## Main Functions

Note: Terminal colors (tmux/vim) are based on light theme.

### [tmux](https://github.com/gpakosz/.tmux.git)

- settings:
  - `.tmux.conf.local`: cross-platform settings
  - `.tmux.conf.local.os`: os-based settings
- plugins:
  - [gitmux](https://github.com/arl/gitmux): show git status in tmux bar; customize color / font in `gitmux.config`
- theme: self-customized in `.tmux.conf.local` (adjust to [papercolor-theme](https://github.com/NLKNguyen/papercolor-theme) light)
- aliases:
  - `t`: open session 0 (default session-name); if attach fail, will create
  - `t <session-name>`: open session with *session-name*; if attach fail, will create
  - `tl`: list all sessions
  - `tk`: kill all sessions except session 0

### vim with [vim-plug](https://github.com/junegunn/vim-plug)

- plugins:
  - [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)
  - [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
  - [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
  - [junegunn/fzf](https://github.com/junegunn/fzf)
  - [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)
  - [tpope/vim-commentary](https://github.com/tpope/vim-commentary)
  - [preservim/nerdtree](https://github.com/preservim/nerdtree)
  - [NLKNguyen/papercolor-theme](https://github.com/NLKNguyen/papercolor-theme)
- theme:
  - [papercolor-theme](https://github.com/NLKNguyen/papercolor-theme) light
- map keys (LEADER: Space):
  - CTRL-T: fzf
  - LEADER-f: fzf with preview window
  - LEADER-l: show git log with preview window
  - LEADER LEADER: nerdtree (sidebar tree browser)
  - LEADER-q: Quit vim (close all buffers)
  - LEADER-w: Close current buffer
  - LEADER-[: Switch to previous buffer
  - LEADER-]: Switch to next buffer


### [fzf](https://github.com/junegunn/fzf)

use fzf as rg(ripgrep)'s backend


### shellrc (zshrc / bashrc)

- add ~/bin to path
- use similar aliases in zsh & bash
- setproxy/unsetproxy on port 1080
- ssh to VPS machines


#### [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)

- plugins:
  - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- theme:
  - self-customized theme 'sol-light'


### hammerspoon for macOS

See [hammerspoon readme](https://github.com/ShangjinTang/dotfiles/blob/master/macos/hammerspoon/README.md)