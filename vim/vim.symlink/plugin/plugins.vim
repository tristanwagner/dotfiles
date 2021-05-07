call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
" Addons
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdtree'
Plug 'alvan/vim-closetag'
Plug 'vim-scripts/vim-auto-save'
" if it is updated you need to recompile it 
" https://github.com/ycm-core/YouCompleteMe:w
" cd plugged/YouCompleteMe && python3 install.py --all
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'

" surrounding ops, like putting ' arround a word, or html tag etc..
Plug 'tpope/vim-surround'

" generate html from notation html > body > div
Plug 'rstacruz/sparkup'

" gr motion
Plug 'vim-scripts/ReplaceWithRegister'

Plug 'christoomey/vim-sort-motion'

Plug 'tmhedberg/matchit'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-indent'
"Plug 'nelstrom/vim-textobj-rubyblock'
"Plug 'ecomba/vim-ruby-refactoring'
"Plug 'vim-scripts/tComment'
Plug 'tpope/vim-commentary'
Plug 'blarghmatey/split-expander'
Plug 'farmergreg/vim-lastplace'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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
Plug 'storyn26383/vim-vue'

" Syntax errors
Plug 'ntpeters/vim-better-whitespace'

" Markdown support
Plug 'junegunn/goyo.vim'
" markdown preview :GripStart
Plug 'PratikBhusal/vim-grip'

" Git support
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'

" Themes
Plug 'altercation/vim-colors-solarized'
Plug 'icymind/NeoSolarized'

" Reasonml
Plug 'reasonml-editor/vim-reason-plus'

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

Plug 'rhysd/vim-clang-format'
Plug 'octol/vim-cpp-enhanced-highlight'

" debugger
Plug 'puremourning/vimspector'

" rainbow parentheses
Plug 'luochen1990/rainbow'

" go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" oneliners into multliners
Plug 'AndrewRadev/splitjoin.vim'

call plug#end()
