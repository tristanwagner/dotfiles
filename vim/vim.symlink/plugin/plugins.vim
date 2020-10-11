call plug#begin('~/.vim/plugged')

" Addons
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdtree'
"Plug 'yegappan/mru'
Plug 'alvan/vim-closetag'
Plug 'vim-scripts/vim-auto-save'
"Plug 'airblade/vim-gitgutter'
"Plug 'ervandew/supertab'
" trying YCM instead of supertab
" if it is updated you need to recompile it 
" https://github.com/ycm-core/YouCompleteMe:w
" cd plugged/YouCompleteMe && python3 install.py --all
Plug 'Valloric/YouCompleteMe'
" should try deoplete
"Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-bundler'
"Plug 'tpope/vim-endwise'

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

"automatic resize window
Plug 'roman/golden-ratio'

Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'

" Tmux integration
"Plug 'benmills/vimux'
"Plug 'christoomey/vim-tmux-navigator'

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
"Plug 'jparise/vim-graphql'
Plug 'leafgarland/typescript-vim'
"Plug 'posva/vim-vue'

" Syntax errors
Plug 'vim-syntastic/syntastic'
Plug 'ntpeters/vim-better-whitespace'

" Markdown support
Plug 'junegunn/goyo.vim'

" Git support
"Plug 'tpope/vim-dispatch'
"Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-fugitive', { 'commit': '444ba9fda5d05aa14c7e8664fa4a66a59c62a550' }

" Themes
Plug 'altercation/vim-colors-solarized'
Plug 'icymind/NeoSolarized'

" Reasonml
Plug 'reasonml-editor/vim-reason-plus'

" Testing
"Plug 'janko-m/vim-test'

" Gist
"Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'

"marks
Plug 'kshenoy/vim-signature'

"multi cursor
"Plug 'terryma/vim-multiple-cursors'

" show next mappings
"Plug 'liuchengxu/vim-which-key'

" session
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

Plug 'rhysd/vim-clang-format'

Plug 'octol/vim-cpp-enhanced-highlight'

call plug#end()
