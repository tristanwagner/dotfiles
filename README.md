# dotfiles

## Installation

Clone this repo to your **home** directory and use [GNU Stow](https://www.gnu.org/software/stow/) to symlink configs.

One-liner:

```shell
curl -fsSL https://raw.githubusercontent.com/tristanwagner/dotfiles/master/install | sh
```

Or manually:

```shell
git clone https://github.com/tristanwagner/dotfiles ~/dotfiles
cd ~/dotfiles
./install
```

The install script handles everything: package installation (brew on macOS, apt/pacman on Linux), oh-my-zsh + plugins, backup of existing configs, stow, and setting zsh as default shell.

Existing configs are backed up to `~/.dotfiles-backup/<timestamp>/` before being replaced. To restore:

```shell
./install restore                  # list available backups
./install restore 20260324-090000  # restore a specific backup
```

The repo mirrors `$HOME` -- directories like `.config/`, `.factory/`, and `.vim/` map directly to their home equivalents.

`--no-folding` creates per-file symlinks so tools like Factory or oh-my-zsh can still write their own files alongside managed ones. `--adopt` takes over existing files on first run.

To re-link after adding new files:

```shell
cd ~/dotfiles && stow --no-folding -t ~ .
```

To unlink:

```shell
cd ~/dotfiles && stow --no-folding -D -t ~ .
```

Files excluded from stowing (README, install script, fonts, etc.) are listed in `.stow-local-ignore`.

## Packages

### brew

```sh
bat
git
cmake
docker
docker-compose
docker-machine
ffmpeg
go
htop
lua
macvim
mpv
ncdu
node
nvm
pkg-config
python
ruby
sqlite
youtube-dl
wezterm
rg
fzf
thefuck
```

### linux

```sh
rofi
git
nodejs
npm
neovim
vim
curl
clang-tidy
gdb
gcc
g++
build-essential
python
python-pip
python3-pip
python3
tmux
rg
zsh
ttf-ancient-fonts
fonts-powerline
cmake
python3-dev
htop
ncdu
xclip
bat
lazydocker
lazygit
```
