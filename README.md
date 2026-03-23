# dotfiles

## Installation

Clone this repo to your **home** directory and use [GNU Stow](https://www.gnu.org/software/stow/) to symlink configs.

```shell
brew install stow
git clone https://github.com/tristanwagner/dotfiles ~/dotfiles
cd ~/dotfiles
./install
stow --no-folding --adopt -t ~ .
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
