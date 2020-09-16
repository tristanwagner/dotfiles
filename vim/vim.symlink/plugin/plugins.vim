call plug#begin('~/.vim/plugged')

" Addons
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdtree'
Plug 'yegappan/mru'
Plug 'alvan/vim-closetag'
Plug 'vim-scripts/vim-auto-save'
"Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
" should try deoplete
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-endwise'

" surrounding ops, like putting ' arround a word, or html tag etc..
Plug 'tpope/vim-surround'

Plug 'tmhedberg/matchit'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'vim-scripts/tComment'
Plug 'jremmen/vim-ripgrep'
Plug 'blarghmatey/split-expander'
Plug 'farmergreg/vim-lastplace'
Plug 'jlanzarotta/bufexplorer'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'roman/golden-ratio'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'

" Tmux integration
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'

" File system navigation
Plug 'tpope/vim-eunuch'
" Vim clap requires vim >  8.1
"Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Syntax highlighting
Plug 'elzr/vim-json'
Plug 'tpope/vim-markdown'
Plug 'groenewege/vim-less'
Plug 'tpope/vim-haml'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'jparise/vim-graphql'
" Plug 'leafgarland/typescript-vim'

" Syntax errors
Plug 'vim-syntastic/syntastic'
Plug 'ntpeters/vim-better-whitespace'

" Markdown support
Plug 'junegunn/goyo.vim'

" Git support
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-fugitive', { 'commit': '444ba9fda5d05aa14c7e8664fa4a66a59c62a550' }

" Themes
Plug 'altercation/vim-colors-solarized'
Plug 'icymind/NeoSolarized'

" Reasonml
Plug 'reasonml-editor/vim-reason-plus'

" Testing
"Plug 'janko-m/vim-test'

" Gist
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'

"marks
Plug 'kshenoy/vim-signature'

"multi cursor
Plug 'terryma/vim-multiple-cursors'

" show next mappings
"Plug 'liuchengxu/vim-which-key'

" session
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

Plug 'rhysd/vim-clang-format'

Plug 'octol/vim-cpp-enhanced-highlight'

" enhanced completion couldnt get it to work lol
"Plug 'Valloric/YouCompleteMe'
"make sure you have build-essential cmake python3-dev
"need to compile it :
"cd ~/.vim/plugged/YouCompleteMe
"python3 install.py --clang-completer --ts-completer
"
"for c/c++:
"follow instructions at https://github.com/ycm-core/YouCompleteMe
"
"download https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/clang+llvm-8.0.1-powerpc64le-linux-ubuntu-16.04.tar.xz
"extract it in for example ~/ycm_temp
"
"cd ~
"mkdir ycm_build
"cd ycm_build
"
"cmake -G \"Unix Makefiles" -DPATH_TO_LLVM_ROOT=~/ycm_temp/llvm_root_dir . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
"
"cmake --build . --target ycm_core --config Release
"
"optional regex ++:
"
"cd ~
"mkdir regex_build
"cd regex_build
"cmake -G \"Unix Makefiles" . ~/.vim/plugged/YouCompleteMe/third_party/ycmd/third_party/cregex
"cmake --build . --target _regex --config Release
"
"for js:
"cd ~/.vim/plugged/YouCompleteMe
""npm install -g --prefix third_party/tsserver typescript

call plug#end()
