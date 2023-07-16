call plug#begin('~/.vim/plugged')

" Addons
" Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdtree'
Plug 'alvan/vim-closetag'
" Plug 'kocotian/vim-dired'

" Plug 'vim-scripts/vim-auto-save'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
" used mainly for coerce see :help abolish-coerce
Plug 'tpope/vim-abolish'

" surrounding ops, like putting ' arround a word, or html tag etc..
Plug 'tpope/vim-surround'

" generate html from notation html > body > div
Plug 'rstacruz/sparkup'

" gr motion
Plug 'vim-scripts/ReplaceWithRegister'

Plug 'christoomey/vim-sort-motion'

Plug 'tmhedberg/matchit'

" move separated values right and left
" also add argument text object
Plug 'AndrewRadev/sideways.vim'

Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'

Plug 'tpope/vim-commentary'
Plug 'blarghmatey/split-expander'
Plug 'farmergreg/vim-lastplace'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File system navigation
Plug 'tpope/vim-eunuch'

" Vim clap requires vim >  8.1
"Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Syntax highlighting
Plug 'nelsyeung/twig.vim'
Plug 'jxnblk/vim-mdx-js'
Plug 'elzr/vim-json'
Plug 'tpope/vim-markdown'
Plug 'groenewege/vim-less'
Plug 'tpope/vim-haml'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
"Plug 'jparise/vim-graphql'
Plug 'leafgarland/typescript-vim'
Plug 'storyn26383/vim-vue'
Plug 'habamax/vim-asciidoctor'
Plug 'rescript-lang/vim-rescript', { 'tag': 'v2.1.0' }
" Reasonml
Plug 'reasonml-editor/vim-reason-plus'
Plug 'rhysd/vim-clang-format'
Plug 'octol/vim-cpp-enhanced-highlight'
" go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Syntax errors
Plug 'ntpeters/vim-better-whitespace'

" Markdown support
Plug 'junegunn/goyo.vim'
" markdown preview :GripStart
Plug 'PratikBhusal/vim-grip'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

" Git support
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'

" Themes
Plug 'morhetz/gruvbox'

" Testing
Plug 'janko-m/vim-test'

"marks
Plug 'kshenoy/vim-signature'

"multi cursor
"Plug 'terryma/vim-multiple-cursors'

" show next mappings
"Plug 'liuchengxu/vim-which-key'

" session
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

" debugger
Plug 'puremourning/vimspector'

" close brackets
Plug 'mapkts/enwise'

" rainbow parentheses
Plug 'luochen1990/rainbow'

" oneliners into multliners
Plug 'AndrewRadev/splitjoin.vim'

" :ColorToggle for interpreting color codes
Plug 'chrisbra/Colorizer'

" Arduino
Plug 'stevearc/vim-arduino'

call plug#end()
