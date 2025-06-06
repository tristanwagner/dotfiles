# dotfiles

## References

- [Learning Vim in a Week](https://mikecoutermarsh.com/boston-vim-learning-vim-in-a-week/)
- [Upcase: The Art of Vim](https://upcase.com/vim)

## Installation

If you have trouble during installation, please open an issue or pull request. :star:

Clone this repo (or your own fork!) to your **home** directory (`/Users/username`).

```shell
brew install stow # or other package manager
git clone https://github.com/tristanwagner/dotfiles ~/dotfiles
cd ~/dotfiles
./install
stow .
```

## VIM

### Vim specific things for windows

We need to install and use gvim on windows, it seems complicated to really  
use it flawlessly in terminal emulators..

After install my vim & config files were located in C:\tools\vim so I just  
took all my config files and copied them to this directory (paste and remplace).

After a :PlugInstall most of the stuff seemed to work althought I had to  
install some powerline fonts for vim-airline to display properly

### Install powerline fonts

Open powershell in admin mode and type

```shell
git clone https://github.com/powerline/fonts.git --depth=1
Set-ExecutionPolicy Bypass
\install.ps1
Set-ExecutionPolicy Default
```

to modify the default font in gvim

```vimscript
" open guifont panel and chose a font
set guifont=*
" print current font setting
set guifont?
" paste the setting in vimrc for example I picked deja vu
set guifont=DejaVu_Sans_Mono_for_Powerline:h18:cANSI:qDRAFT
```

## Stuff to install

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
