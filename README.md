
dotfiles
===================

Forked from [mcscoutermarsh's dotfiles](https://github.com/mscoutermarsh/dotfiles)

## New to Vim?
+ [Learning Vim in a Week](https://mikecoutermarsh.com/boston-vim-learning-vim-in-a-week/)
+ [Upcase: The Art of Vim](https://upcase.com/vim) 

If you're brand new to Vim, I recommend using [ThoughtBot's dotfiles](https://github.com/thoughtbot/dotfiles). They are better maintained than mine :).  

## Installation

If you have trouble during installation, please open an issue or pull request. :star:

Clone this repo (or your own fork!) to your **home** directory (`/Users/username`).
```
git clone https://github.com/tristanwagner/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

### Vim specific things for windows

We need to install and USE gvim on windows, it seems complicated to really use it flawlessly in terminal emulators..

After install my vim & config files were located in C:\tools\vim so I just took all my config files and copied them to this directory (paste and remplace).

After a :PlugInstall most of the stuff seemed to work althought I had to install some powerline fonts for vim-airline to display properly

#### Install powerline fonts

Open powershell in admin mode and type

```shell
$ git clone https://github.com/powerline/fonts.git --depth=1
$ Set-ExecutionPolicy Bypass
$ \install.ps1
$ Set-ExecutionPolicy Default
```
