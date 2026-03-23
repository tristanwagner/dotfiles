# dotfiles

Forked from [mcscoutermarsh's dotfiles](https://github.com/mscoutermarsh/dotfiles)

## References

- [Learning Vim in a Week](https://mikecoutermarsh.com/boston-vim-learning-vim-in-a-week/)
- [Upcase: The Art of Vim](https://upcase.com/vim)
- [ThoughtBot's dotfiles](https://github.com/thoughtbot/dotfiles)

## Installation

If you have trouble during installation, please open an issue or pull request. :star:

Clone this repo (or your own fork!) to your **home** directory (`/Users/username`).

```shell
git clone https://github.com/tristanwagner/dotfiles ~/dotfiles
cd ~/dotfiles
./install
```

### Stow

Configs that map to `~/.<name>` directories are managed with [GNU Stow](https://www.gnu.org/software/stow/).

Install stow:

```shell
brew install stow
```

The repo structure mirrors `$HOME`. Directories like `.factory/` and `.config/` map directly to their home equivalents.

To link everything:

```shell
cd ~/dotfiles
stow --no-folding -t ~ .
```

On first run, use `--adopt` to let stow take over existing files:

```shell
stow --no-folding --adopt -t ~ .
```

`--no-folding` creates per-file symlinks so other tools (like Factory) can still write their own files alongside the managed ones.

To unlink:

```shell
cd ~/dotfiles
stow --no-folding -D -t ~ .
```

Files that shouldn't be stowed (README, install script, etc.) are listed in `.stow-local-ignore`.

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

- oh my zsh
- powerline10k
- zsh-nvm / nvm
- ag the silver searcher
- fzf
- thefuck
- bat
- rust/cargo
