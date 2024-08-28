# dotfiles

Dotfiles for [ArchLinux](ArchLinux) x86_64 & [Ubuntu 22.04](Ubuntu 22.04) x86_64, managed by [dotbot](https://github.com/anishathalye/dotbot).

An out-of-the-box configuration with multiple features, easy to install and customize.

**PRs are welcome.**

Notes:

1. **It's not a light-weight configuration; and only support for [zsh](zsh).**
2. **If you are in China Mainland, recommend to use a proxy set `PROXY_IP` and `PROXY_ENABLED`.**
3. **There is no uninstall script yet.**. Before installation please try in docker or virtual machine first.
4. **Suggest to use [latest release](https://github.com/ShangjinTang/dotfiles/releases).**

## Supported OS

Fully supported and keep up-to-date:

- **[ArchLinux](ArchLinux) x86_64** (also supported in WSL2)
- **[Ubuntu 22.04](Ubuntu 22.04) x86_64** (also supported in WSL2)

Note: for Ubuntu, only recently Ubuntu LTS version is supported, because the required tools/packages are hard to maintain across different Ubuntu versions.

Partially supported:

- **Other Ubuntu x86_64 Versions**
  - Even running on Ubuntu 16.04 (offline, no root permission) can be OK with full features enabled
    - see: [How to Install on an Old-school Server](https://github.com/ShangjinTang/dotfiles/wiki/How-to-Install-on-an-Oldschool-Server)
  - Essential Packages:
    - executables: **zsh**, **rust & cargo**, **mise**, **nvim**, **nodejs**, **tmux**, **rg(ripgrep)**, **fd(fd-find)**, **delta**
    - python3 packages: **pynvim**
  - You can download x86_64 preset executables in [CLI Prebuilts](https://github.com/ShangjinTang/cli-prebuilts).

## Installation

If you are in China Mainland, please use a proxy to bypass GFW before installation. Otherwise some steps may fail.

```bash
vim ~/.zshrc.local
```

```bash
export PROXY_IP="127.0.0.1:7890"
export PROXY_ENABLED=1
```

For more customized environments, see [zshrc.pre](https://github.com/ShangjinTang/dotfiles/blob/master/configs/zsh/zshrc.pre)

### ArchLinux x86_64

```bash
sudo pacman -Sy zsh git neovim
chsh -s $(which zsh)
```

Log out and re-login to make sure the shell is changed to `zsh`.

```bash
git clone https://github.com/ShangjinTang/dotfiles ~/.dotfiles --depth=1
~/.dotfiles/install && source ~/.zshrc

# Essential packages
mise global rust@latest

# recommend to use mise to control python versions
sudo pacman -Sy libxcrypt-compat # required to compile python with 'mise'
mise global python@3.10

# Essential: support for python plugins in Nvim
pip3 install pynvim

# install the pre-defined packages
pip3 install hydra-core "typer[all]" && mpac install
```

### Ubuntu 22.04 x86_64

```bash
sudo apt update
sudo apt install -y zsh git
chsh -s $(which zsh)
```

Log out and re-login to make sure the shell is changed to `zsh`.

```bash
git clone https://github.com/ShangjinTang/dotfiles ~/.dotfiles --depth=1
~/.dotfiles/install && source ~/.zshrc

# Essential packages
mise global rust@latest
mise global neovim@latest
mise global node@latest
mise global lazygit@latest
mise global zoxide@latest

# tmux
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config unzip
mise global tmux@latest

# python: recommend to use mise to control python versions
sudo apt install -y libssl-dev liblzma-dev # dependency for python build
mise global python@3.10                    # or 'mise global python@latest'

# Essential: support for python plugins in Nvim
sudo apt install python3-pip
pip3 install pynvim

# install the pre-defined packages
pip3 install hydra-core "typer[all]" && sudo mapt install
```

### Other Ubuntu x86_64 Versions

Refer to installation above.
For some essential binaries, use [mise](https://github.com/jdx/mise) and [Cli Prebuilts](https://github.com/ShangjinTang/cli-prebuilts).

## NVIM Plugins Installation

1. Entering nvim, and wait the plugins to be installed.

- First install cycle: LunarVim plugins
- Second install cycle: Additional plugins

2. **Execute `:UpdateRemotePlugins`**.

Note: NVIM sometimes might be buggy, because some error just appears in the first-time installation. Scroll down to bottom to see some fixes & tips.

## Core Features

- AI support to speed up development inside NVIM
  - NVIM: copilot-cmp (type `:Copilot auth` for first time use)
  - NVIM: ChatGPT.nvim (requires `$OPENAI_API_KEY`)
  - CLI tool: [sgpt](https://github.com/TheR1D/shell_gpt) (requires `$OPENAI_API_KEY`)
- ArchLinux x86_64 Packages
  - Provide a script `mpac` with pre-set multi `pacman` installation
- Ubuntu 22.04 x86_64 Packages
  - Provide a script `mapt` with pre-set multi `apt` installation
- Python3 Packages
  - Provide a script `mpip` with pre-set multi `pip` installation
- [dotbot](https://github.com/anishathalye/dotbot)
  - settings with multi-stages
  - support customized settings (in `~/.dotfiles.local`)
  - automatically download some [nerdfonts](nerdfonts) to `~/.fonts`
- [zsh](zsh), based on [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
  - useful plugins such as:
    - `fzf-tab`
    - `zsh-autosuggestions`
    - `zsh-syntax-highlighting`
  - settings with multi-stages
    - `~/.zshrc.pre` -> `~/.zshrc` -> `~/.zshrc.local` -> `~/.zshrc.post`
  - support customized settings (in `~/zshrc.local`)
- [mise](mise)
  - [mise](mise) is like [asdf](asdf), but much more fast and user-friendly
  - use `~/.tool-versions` to install essential packages
- [nvim](nvim) (>=0.10)
  - re-use configuration from [LunarVim](LunarVim) without manual install it first
  - LSPs are auto installed using [mason-lspconfig.nvim](mason-lspconfig.nvim)
  - add fuzzy prompt for cmdline ([wilder.nvim](wilder.nvim)) and modern message UI ([noice.nvim](noice.nvim))
  - customized key-bindings and seperated from original key-bindings
  - auto format on file save
  - toggle terminal with `Ctrl-\`, `Alt-1`, `Alt-2`, `Alt-3`
- [tmux](tmux) (>=3.3a)
  - customized theme and bar
  - [gitmux](gitmux) support
  - [tmuxp](tmuxp) support
- unified theme Catppuccin Frappe (dark background) with transparency
  - support white(non-transparent) & dark(transparent) theme with [lualine.nvim](lualine.nvim), [nvim-tree.lua](nvim-tree.lua), [toggleterm.nvim](toggleterm.nvim), etc
  - customized theme for `tmux` & `gitmux`
  - customized theme for shell prompt
  - third-party (`bat`, `radare2`) built-in dark theme

## Features for Simplify Workflow

- global `.gitconfig` and `.gitignore`
- simplify proxy settings
  - preset: `$PROXY_IP` `$PROXY_ENABLED`
  - toggle: `setproxy` `unsetproxy`
- simplify tmux session manipulations
  - `t`: open session 0 (default session-name); if attach fail, will create
  - `t <session-name>`: open session with _session-name_; if attach fail, will create
  - `tl`: list all sessions
  - `tk`: kill all sessions except session 0
- add auto edit for fzf
  - use ALT-V to quick edit without typing `v xxx` (`v` is alias for `nvim`)
- simplify `$PATH` settings
  - use `_PATHAPPEND`, `_PATHPREPEND` to modify PATHs
  - use `_DIRCREATE` to create a directory if not exists
- simplify change between directories
  - `cu` (short for `cdup`)
    - `cu NUMBER`: e.g. `cu 3` => `cd ../../..`
    - `cu UPPER_DIR_NAME`: cd up to nearest `UPPER_DIR_NAME`
  - `cg` : cd to git root directory
  - `ce` (short for `cdup_to_exists`)

## Features for Simplify Software Development

- simplify C / C++ development
  - `rc` / `rcpp` to run C / C++ files under current directory with provided flags
  - `cmakebuild` to build make projects under PROJECT ROOT
    - auto generate `compile_commands.json`
- auto code format on save using `neoformat`
  - C / C++ (based on `~/.clang-format`)
  - Python
  - Java
  - Bash
  - Lua
  - ...
- simplify nvim tasks
  - asynctask: compilation inside nvim under PROJECT ROOT based on `.tasks`

### Machine Learning Framework Install (Ubuntu 22.04 x86_64)

```bash
~/bin/mamba_create_env_pyml
conda activate pyml
```

Then follow [Gist TF_Torch_GPU_Installation](https://gist.github.com/ShangjinTang/e19d6c03334957f0f72ae59c0583d647).

## Customization

1. Add configuration files
2. Edit `install.conf.yaml` to create symlink
3. Edit `install.pre` or `install.post` to customize the behavior before or after installation
4. For configurations override, see [How to Create Override Configurations](https://github.com/ShangjinTang/dotfiles/wiki/How-to-Create-Override-Configurations)

## Tips & Issue Fix

### mise

- If you do not have a proxy, you might occur this issue in China Mainland. `mise install python` is downloading from https://www.python.org, maybe the download is slow.
- If you have issue with `mise` package, please remove the issue package from `.tool-versions` and manually install it.
- If you need to use a different version in a folder, use `mise local <some-package>@<version-number>`
- `mise` support all [asdf-plugins](https://github.com/asdf-vm/asdf-plugins)

### nvim

1. You always need to use `:UpdateRemotePlugins` in nvim after python environment changes.
2. `pynvim` must be installed in current python.

#### nvim plugins

Sometimes you need to update plugins to fix plugin issues by executing `LvimSyncCorePlugins` in nvim.

#### nvim treesitter

Sometimes you need to update treesitter to fix it's issues by executing `:TSUpdate` in nvim.

This can solve issue as below:

```plain
treesitter/highlighter: Error executing lua:
.../share/nvim/runtime/lua/vim/treesitter/query.lua:161: query: invalid node type at position XXX
```

#### mason

Sometimes you have python binaries in `~/.local/share/nvim/mason/bin`, but cannot execute, e.g. `black` `isort`. And nvim prints related error or warning.

This is often due to python version/environment changes. To resolve it, run command below:

```python
rm -rf ~/.local/share/nvim/mason
```

Then open nvim to do a fresh install.

[ArchLinux]: https://archlinux.org/
[Ubuntu 22.04]: https://releases.ubuntu.com/jammy/
[zsh]: https://www.zsh.org/
[mise]: https://mise.jdx.dev/
[asdf]: https://asdf-vm.com/
[tmux]: https://github.com/tmux/tmux/wiki
[gitmux]: https://github.com/arl/gitmux
[tmuxp]: https://github.com/tmux-python/tmuxp
[LunarVim]: https://lunarvim.org/
[nvim]: https://neovim.io/
[nerdfonts]: https://www.nerdfonts.com/
[mason-lspconfig.nvim]: https://github.com/williamboman/mason-lspconfig.nvim
[wilder.nvim]: https://github.com/gelguy/wilder.nvim
[noice.nvim]: https://github.com/folke/noice.nvim
[lualine.nvim]: https://github.com/nvim-lualine/lualine.nvim
[nvim-tree.lua]: https://github.com/nvim-tree/nvim-tree.lua
[toggleterm.nvim]: https://github.com/akinsho/toggleterm.nvim
