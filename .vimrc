" example of json to js substitute
" :%s/\"\(.*\)\":/\1:/g 
" \1 = what ever is selected between \( and \)

" this should fix launching vim in replace mode
" set t_u7=

if has('win32')
  source C:\tools\vim\vim82\plugin\plugins.vim
else
  source ~/.vim/plugin/plugins.vim
  " use interactive zsh mode to be able to call aliases and zshrc functions
  let &shell='/bin/zsh -i'
endif

" rebind alt key modifier
" the bind can depends from terminal emulators,
" to get the character that the bind produce you must
" go in insert mode and press ctrl-v and then the keybind
" for example now ctrl-v alt-j produces ∆
if has("mac") || has("macunix")
  nmap Ï <M-j>
  nmap È <M-k>
  nmap Ì <M-h>
  nmap ¬ <M-l>
  nmap ∆ <M-j>
  nmap ˚ <M-k>
  nmap ˙ <M-h>
  nmap å <M-a>
  nmap ∑ <M-w>
  nmap ç <M-c>
  nmap ø <M-o>
  nmap ß <M-s>
  nmap ≤ <M-,>
  nmap … <M-;>
  nmap π <M-p>
  nmap ƒ <M-f>
  nmap ˙ <M-h>
  nmap ω <M-z>
  nmap ≈ <M-x>
  vmap å <M-a>
  vmap ∑ <M-w>
  vmap Ï <M-j>
  vmap È <M-k>
  vmap Ì <M-h>
  vmap ¬ <M-l>
  vmap ∆ <M-j>
  vmap ˚ <M-k>
  vmap ˙ <M-h>
  vmap ç <M-c>
  vmap ø <M-o>
  vmap ß <M-s>
  vmap ≤ <M-,>
  vmap … <M-;>
  vmap π <M-p>
  vmap ƒ <M-f>
  vmap ˙ <M-h>
  vmap ω <M-z>
  vmap ≈ <M-x>
endif

" set default font for gui per platform
" I use gui only on windows because gvim is better imo
" see readme to install powerline fonts on windows
if has("gui_running")
    if has("gui_gtk2")
      set guifont=Inconsolata\ 12
    elseif has("gui_macvim")
      autocmd GUIEnter * set vb t_vb=
      set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
      set guifont=DejaVu_Sans_Mono_for_Powerline:h18:cANSI:qDRAFT
    endif
endif

" Leader Mappings
map <Space> <leader>
"map <Leader>w :update<CR>
map <Leader>q :qall<CR>

" Find/replace
nnoremap <leader>r :%s/\<<C-r><C-w>\>//gci<Left><Left><Left><Left>

" Nerdtree
" map <C-B> :NERDTreeToggle<CR>

" show hidden files
" let NERDTreeShowHidden=1
"
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
" autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
"     \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Close the tab if NERDTree is the only window remaining in it.
" NOTE: I use the other method instead because when switching windows it
" switch buffers toe
" autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" make tab go to matching pair
" this overrides ctrl-i which is actually useful ...
"nnoremap <Tab> %

" Visual mode pressing * searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>

" useful tabs keybinds
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" move through windows with ctrl
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Disable highlights when pressing ENTER
nnoremap <silent> <cr> :noh<cr>

" search result mid screen
nnoremap n nzz
nnoremap N Nzz

"Cope
"Query :help cope if you are unsure what cope is. It's super useful!
"When you search with Ack.vim or other quickfix windows, display your results in cope by doing: <leader>cc
"To go to the next search result do: <leader>n
"To go to the previous search results do: <leader>p
"Cope mappings:
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
"close quickfix
map <leader>cq :ccl<cr>
" next
map <leader>n :cn<cr>
" previous
map <leader>p :cp<cr>

" to apply a command to all files in quicklist we can do
" :cfdo or :cdo
" if it modifies the file we can to :cdo <stuff> | update
" | update allow to save the file after the modification
" This is an example of bulk search and replace
" populate de arglist with sheel cmd
" :args `git grep -l findme`
" :argdo %s/findme/replacement/gc | update

function QuitTabOrBuffer()
  if tabpagenr('$') > 1
    execute "tabclose"
  elseif bufnr('$') > 1
    execute "bw"
  else
    execute "q"
  endif
endfunction

" ex mode is useless instead quite current context
nnoremap <silent> Q :call QuitTabOrBuffer()<CR>

" ragequit
nnoremap <C-q> :q!<CR>

" grab between
" nnoremap <leader>gb :let t=[] | %s/\(<+b-start+>\)\@<=\(<+pattern+>\)\(<+b-end+>\)\@=/\=add(t,submatch(2))[len(t)-1]/g

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

"-------------------------------------------------------------------------------
" Colors & Formatting
"-------------------------------------------------------------------------------

syntax enable

" Colorscheme
set termguicolors

let g:gruvbox_invert_selection = 0
let g:gruvbox_invert_tabline = 0

colorscheme gruvbox

set background=dark
set colorcolumn=80                    " shoz a marker on column 80
set mouse=a                           " enable mouse
set list                              " enable invisible chars
set nocompatible
set hidden                            " hidde buffers instead of closing them
set smartindent
set title
set wildmenu                          " Tab autocomplete in command mode
set backspace=indent,eol,start        " http://vi.stackexchange.com/a/2163
set clipboard=unnamed                 " Clipboard support (OSX)
set laststatus=2                      " Show status line on startup
set splitbelow splitright             " Open new splits to the right
"set splitbelow                       " Open new splits to the bottom
"set lazyredraw                       " Reduce the redraw frequency, this one fuck up the scroll
set nolazyredraw                      " Reduce the redraw frequency
set ttyfast                           " Send more characters in fast terminals
set nowrap                            " Don't wrap long lines
set listchars=extends:→               " Show arrow if line continues rightwards
set listchars+=precedes:←             " Show arrow if line continues leftwards
set nobackup nowritebackup noswapfile " Turn off backup files
set noerrorbells novisualbell         " Turn off visual and audible bells
set expandtab shiftwidth=2 tabstop=2  " Two spaces for tabs everywhere
set history=500
set hlsearch                          " Highlight search results
set ignorecase smartcase              " Search queries intelligently set case
set incsearch                         " Show search results as you type
set timeoutlen=1000 ttimeoutlen=0     " Remove timeout when hitting escape
set showcmd                           " Show size of visual selection
set smarttab

set pastetoggle=<F12>                  " Paste mode is cool if you paste a big chunk of text

" Persistent undo
set undodir=~/.vim/undo/
set undofile
set undolevels=1000
set undoreload=10000

" Ignored files/directories from autocomplete
set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.log,*.pyc,*.sqlite,*.sqlite3,*.min.js,*.min.css,*.tags
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.pdf,*.dmg,*.app,*.ipa,*.apk,*.mobi,*.epub
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.doc,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*/.git/*,*/.svn/*,*.DS_Store
set wildignore+=*/node_modules/*,*/nginx_runtime/*,*/build/*,*/logs/*,*/dist/*,*/tmp/*

" Set to auto read when a file is changed from the outside
set autoread

set t_vb=
set tm=500

set tags=./tags,tags

"-------------------------------------------------------------------------------
" Interface
"-------------------------------------------------------------------------------

set number            " Enable line numbers
set scrolloff=5       " Leave 5 lines of buffer when scrolling
set sidescrolloff=10  " Leave 10 characters of horizontal buffer when scrolling

" kitty issue
let &t_ut=''

"-------------------------------------------------------------------------------
" Autocmd, Specific file types and snippets
"-------------------------------------------------------------------------------

" .jsx extension not required to highlight jsx
let g:jsx_ext_required = 0

" Delete trailing white space on save, useful for some filetypes ;)
function! CleanExtraSpaces()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  silent! %s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction

command! -nargs=0 TrimSpaces call CleanExtraSpaces()

if has("autocmd")
  " this bugs out coc completion theme
  " autocmd vimenter * colorscheme gruvbox
  " or
  " autocmd vimenter * ++nested colorscheme gruvbox
  autocmd vimenter * AirlineTheme gruvbox

  autocmd BufWritePre *.txt,*.js,*.ts,*.json,*.adoc,*.py,*.wiki,*.sh,*.coffee,*.vim :call CleanExtraSpaces()

  " File skeletons
  autocmd BufNewFile README.md 0r ~/dotfiles/vim/vim.symlink/skeletons/README.md
  autocmd BufNewFile *.sh 0r ~/dotfiles/vim/vim.symlink/skeletons/bash.sh
  autocmd BufNewFile index.html 0r ~/dotfiles/vim/vim.symlink/skeletons/index.html

  " turn off syntax if file is big
  autocmd Filetype css,scss if getfsize(@%) > 1000000 | setlocal syntax=OFF | endif

  "json fold
  " autocmd filetype json syntax on
  " autocmd filetype json set foldmethod=syntax

  " syntax and fold for json < 10 kB
  autocmd Filetype json if getfsize(@%) > 1000000 | setlocal syntax=OFF | endif
  " this seems to bug airline tabline theme when I edit a json file the tabs
  " are fked
  " autocmd Filetype json if getfsize(@%) > 10000 | setlocal syntax=OFF | else | syntax on | setl foldmethod=syntax  | endif

  " Set filetype correctly for JSON-based lint config files
  autocmd BufNewFile,BufRead .stylelintrc,.eslintrc,.prettierrc,.babelrc,*.json.symlink set filetype=json

  " Set filetype correctly for lua-based files
  autocmd BufNewFile,BufRead *.lua.symlink set filetype=lua

  " Set filetype correctly for objective c files
  autocmd BufNewFile,BufRead *.m,*.mm set filetype=objc

  " generate ctags on update
  autocmd BufWritePost *.c,*.h silent! execute '!ctags . &' | redraw!

  autocmd filetype cpp call SetCPPOptions()
  autocmd filetype c call SetCOptions()
  autocmd FileType python call SetPythonOptions()
  autocmd FileType go call SetGoOptions()
  autocmd filetype html call SetHtmlOptions()
  autocmd filetype vue call SetVueOptions()
  autocmd filetype typescript call SetTSOptions()
  autocmd filetype javascript call SetJSOptions()
  autocmd filetype jsx call SetJSXOptions()
  autocmd filetype tsx call SetTSXOptions()
  autocmd filetype vim call SetVIMOptions()
  autocmd FileType rescript call SetRescriptOptions()
  " Properly disable sound on errors on MacVim
  if has("gui_macvim")
      autocmd GUIEnter * set vb t_vb=
  endif


  "Makefile requires hard tabs -.-
  autocmd FileType make setlocal noexpandtab softtabstop=0
  autocmd FileType asm set syn=nasm
  " update file
  autocmd FocusGained,BufEnter * checktime

  " Return to last edit position when opening files (You want this!)
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" execute compile file
command! -nargs=0 Execute !"./%:r"
command! -nargs=0 TExecute term "./%:r"

nnoremap <F2> :Execute
nnoremap <F5> :TExecute

if exists(':Compile')
  nnoremap <F1> :Compile
endif

function! SetCPPOptions()
  command! -nargs=0  Compile !g++ -std=c++14 -g -Wshadow -Wall -o "%:r" "%" -O2 -Wno-used-result <CR>
endfunction

function! SetCOptions()
  command! -nargs=0  Compile !gcc -g -Wshadow -Wall -o "%:r" "%" -O2<CR>
  "nnoremap <F5> :w <bar> term"./%:r"<CR>
endfunction

function! SetJSOptions()
  command! -nargs=0  Execute !"node ./%:r"
  "snippets
  call JSSnippets()
endfunction

function! JSSnippets()
  " Wrap in logging
  nmap <leader>l yssfconsole.log<cr>
  "snippets
  nnoremap ,for o<Esc>:-1read $HOME/.vim/snippets/js/fori.js<CR>f.i
  nnoremap ,fin o<Esc>:-1read $HOME/.vim/snippets/js/forin.js<CR>f)i
  nnoremap ,fof o<Esc>:-1read $HOME/.vim/snippets/js/forof.js<CR>f)i
  nnoremap ,whi o<Esc>:-1read $HOME/.vim/snippets/js/while.js<CR>f)i
  nnoremap ,swi o<Esc>:-1read $HOME/.vim/snippets/js/switch.js<CR>f)i
  nnoremap ,nfn o<Esc>:-1read $HOME/.vim/snippets/js/nfn.js<CR>f=hi
  nnoremap ,clg o<Esc>:-1read $HOME/.vim/snippets/js/clg.js<CR>f)i
  nnoremap ,clo o<Esc>:-1read $HOME/.vim/snippets/js/clo.js<CR>:s/<++>//g<left><left>
  nnoremap ,cti o<Esc>:-1read $HOME/.vim/snippets/js/cti.js<CR>f'a
  nnoremap ,cte o<Esc>:-1read $HOME/.vim/snippets/js/cte.js<CR>f'a
  nnoremap ,ctm ddo<Esc>:-1read $HOME/.vim/snippets/js/ctm.js<CR>jVp:%s/<++>//g<left><left>
  nnoremap ,prom o<Esc>:-1read $HOME/.vim/snippets/js/prom.js<CR>ji<Tab>
  nnoremap ,sto o<Esc>:-1read $HOME/.vim/snippets/js/sto.js<CR>ji<Tab>
  nnoremap ,sti o<Esc>:-1read $HOME/.vim/snippets/js/sti.js<CR>ji<Tab>
  nnoremap ,anfn i<CR><Esc>:-1read $HOME/.vim/snippets/js/anfn.js<CR>0i<BS><Esc>JF)i
  nnoremap ,imp o<Esc>:-1read $HOME/.vim/snippets/js/imp.js<CR>:s/<++>//g<left><left>
  nnoremap ,imn o<Esc>:-1read $HOME/.vim/snippets/js/imn.js<CR>f'a
  nnoremap ,imd o<Esc>:-1read $HOME/.vim/snippets/js/imd.js<CR>f}i
  nnoremap ,mde o<Esc>:-1read $HOME/.vim/snippets/js/mde.js<CR>f}i
  nnoremap ,cla :-1read $HOME/.vim/snippets/js/class.js<CR>:%s/<++>//g<left><left>
endfunction

function! SetTSOptions()
  "snippets
  call JSSnippets()
  setlocal ts=2 sts=2 sw=2
endfunction

function! SetVueOptions()
  call JSSnippets()
  let g:vue_pre_processors = 'detect_on_enter'
endfunction

function! SetHtmlOptions()
  nnoremap <F2> :w <bar> !open "%"<CR>
  call JSSnippets()
endfunction

function! SetJSXOptions()
  call JSSnippets()
endfunction

function! SetTSXOptions()
  call JSSnippets()
endfunction

function! SetGoOptions()
  " Wrap in logging
  nmap <leader>l yssfmt.Println<cr>
  "execute
  nnoremap <F2> :w <bar> :GoRun<CR>
  "doc
  nnoremap <F1> :w <bar> :GoDoc<CR>
endfunction

function! SetPythonOptions()
  " Wrap in logging
  nmap <leader>l yssfprint<cr>
  "execute
  nnoremap <F2> :w <bar> !python3 "%"<CR>
endfunction

function! SetVIMOptions()
  "snippets
  call VIMSnippets()
endfunction

function VIMSnippets()
  " ch for comment header
  nnoremap ,ch o<Esc>:-1read $HOME/.vim/snippets/vim/comment-header.vim<CR>jA
endfunction

function SetRescriptOptions()
  nnoremap <silent> <buffer> gd :RescriptJumpToDefinition<CR>
  set omnifunc=rescript#Complete
endfunction

" html skeleton
nnoremap ,html :-1read $HOME/.vim/snippets/html/skeleton.html<CR>7jf>a

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

" Showcase comments in italics
highlight Comment cterm=italic gui=italic

" Easy tab navigation
nnoremap <S-Left> :tabprevious<CR>
nnoremap <S-Right> :tabnext<CR>
" Buffers navigation
nnoremap <S-Up> :bn<CR>
nnoremap <S-Down> :bp<CR>

" move to next/previous error
nnoremap <M-Up> :lprevious<CR>
nnoremap <M-Down> :lnext<CR>

" redo
nnoremap U :redo<CR>

" yank and keep cursor at end of yank
vmap y y']

" Shortcuts for vim-test
" Run test under cursor
nmap <silent> <leader>tu :w \| :TestNearest<CR>
" Run current file (otherwise last file)
nmap <silent> <leader>tf :TestFile<CR>
" Visit last test you ran
nmap <silent> <leader>tl :TestLast<CR>
" run all test
nmap <silent> <leader>ts :TestSuite<CR>
" visit last edited test file
nmap <silent> <leader>tv :TestVisit<CR>

let g:test#preserve_screen = 1
" make test commands execute using dispatch.vim

let test#strategy = "vimterminal"
" specify config file
" let g:test#javascript#jest#executable = 'jest --config ./config/jest/jest.conf.js'
let g:test#javascript#jest#options = '--config ./config/jest/jest.conf.js'

let g:auto_save = 0  " enable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0 " do not save in insert mode
let g:auto_save_events= ["InsertLeave", "TextChanged", "FocusLost"]

" airline conf
" enable airline tabs
let g:airline#extensions#tabline#enabled = 1

" formatted tab names
let g:airline#extensions#tabline#formatter = 'unique_tail'

" powerline
let g:airline_powerline_fonts = 1

" Get off my lawn - helpful when learning Vim :)
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
"
"-------------------------------------------------------------------------------
" Neovim-specific configurations
"-------------------------------------------------------------------------------

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  set termguicolors
  "colorscheme NeoSolarized
  set background=dark

  " Fix vim-tmux-navigator <C-h> https://git.io/viGRU
  "nmap <BS> <C-W>h

  " Fix vim-tmux-navigator <C-h> https://git.io/vS5QH
  "nmap <BS> :<C-u>TmuxNavigateLeft<CR>
  " Terminal Function
  let g:term_buf = 0
  let g:term_win = 0
  function! TermToggle(height)
    if win_gotoid(g:term_win)
      hide
    else
      botright new
      exec "resize " . a:height
      try
        exec "buffer " . g:term_buf
      catch
        call termopen($SHELL, {"detach": 0})
        let g:term_buf = bufnr("")
        set nonumber
        set norelativenumber
        set signcolumn=no
      endtry
      startinsert!
      let g:term_win = win_getid()
    endif
  endfunction
  " Toggle terminal on/off (neovim)
  nnoremap <A-t> :call TermToggle(12)<CR>
  inoremap <A-t> <Esc>:call TermToggle(12)<CR>
  tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>
endif

" Execute a macro over a visual range
" would be the equivalent to
" select visual range and type
" :'<,'>normal @<macro letter>
"xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>"

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

if executable("s")
  " a function to call !s from string
  function SearchString(textobject)
    execute "normal yi" . a:textobject
    execute ":silent !s ". getreg('"')
    execute ":redraw!"
  endfunction

  nnoremap <leader>si' :call SearchString("'")<CR>
  nnoremap <leader>si" :call SearchString('"')<CR>
  nnoremap <leader>sl :call SearchString('l')<CR>
endif

" FZF
nnoremap gb <Esc><Esc>:Buffers!<Cr>
nnoremap <C-f> <Esc><Esc>:Files!<Cr>
inoremap <C-f> <Esc><Esc>:BLines!<Cr>
nnoremap gco <Esc><Esc>:BCommits!<Cr>

let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['right,50%', 'ctrl-/']

if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  let g:rg_command = '
    \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
    \ -g "!*.{min.js,swp,o,zip}"
    \ -g "!**/{.git,node_modules,vendor}/*" '

  command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
  nnoremap <C-/> :execute "F"<CR>
endif
" function! s:grep_to_qf(...) abort
"   return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
" endfunction

" nnoremap <silent><nowait> <leader>s  :cgetexpr <SID>grep_to_qf(expand('<cword>'))<CR>
" command! -nargs=+ Find cgetexpr <SID>grep_to_qf(<f-args>)

"--
" COC
"--
" interesting conf to look
" https://github.com/fannheyward/init.vim/blob/master/init.vim
let g:coc_global_extensions = [
      \'coc-dictionary',
      \'coc-explorer',
      \'coc-ecdict',
      \'coc-eslint',
      \'coc-git',
      \'coc-go',
      \'coc-html',
      \'coc-json',
      \'coc-lists',
      \'coc-markdownlint',
      \'coc-marketplace',
      \'coc-mocword',
      \'coc-pairs',
      \'coc-sh',
      \'coc-snippets',
      \'coc-sumneko-lua',
      \'coc-tag',
      \'coc-tsserver',
      \'coc-typos',
      \'coc-vimlsp',
      \'coc-xml',
      \'coc-yaml',
      \'coc-yank',
      \'coc-phpls',
      \'coc-stylelintplus',
      \'coc-cssmodules',
      \'coc-prettier',
      \'coc-clangd',
      \]

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <S-TAB> coc#refresh()
endif

nmap <silent> gl :CocList<CR>
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gd :call <SID>go_to_definition()<CR>
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gp <Plug>(coc-references)
nmap <leader>jr <Plug>(coc-references)
" Symbol renaming.
nnoremap <silent> gn <Plug>(coc-rename)
nnoremap <leader>sr :call CocAction('refactor')<CR>
nnoremap <leader>sn :call CocAction('rename')<CR>

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)<CR>
nmap <leader>a  <Plug>(coc-codeaction-selected)<CR>

" Remap keys for applying codeAction to the current buffer.
nmap <leader>jf  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>ja  <Plug>(coc-fix-current)

" Formatting selected code.
" TODO: find bind
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use K to show documentation in preview window.
nmap <silent> gk :call <SID>show_documentation()<CR>

set completeopt+=preview

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

function! s:go_to_definition()
  if CocActionAsync('jumpDefinition')
    return v:true
  endif

  let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" || ret =~ "错误"
    call searchdecl(expand('<cword>'))
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,javascript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" original way using =
command! -nargs=0 BFormat exe 'normal gg=G'

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nmap <silent><nowait> <M-a>  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nmap <silent><nowait> <M-w>  :<C-u>CocList extensions<cr>
" Show commands.
nmap <silent><nowait> <M-c>  :<C-u>CocList commands<cr>
" Find symbol of current document.
nmap <silent><nowait> <M-o>  :<C-u>CocList outline<cr>
" Search workspace symbols.
nmap <silent><nowait> <M-s>  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nmap <silent><nowait> <M-,>  :<C-u>CocNext<CR>
" Do default action for previous item.
nmap <silent><nowait> <M-;>  :<C-u>CocPrev<CR>
" Resume latest coc list.
nmap <silent><nowait> <M-p>  :<C-u>CocListResume<CR>
""""""

command! -nargs=+ -complete=custom,s:GrepArgs Rg exe 'CocList grep '.<q-args>

function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction

" Keymapping for grep word under cursor with interactive mode
nnoremap <silent> <Leader>cf :exe 'CocList -I --input='.expand('<cword>').' grep'<CR>
nnoremap <silent><nowait> <M-f> :exe 'CocList -I --input='.expand('<cword>').' grep'<CR>

" Grep visual selection
" vnoremap <leader>g :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
vnoremap <leader>g :<C-u>call <SID>GrepFromSelected("v")<CR>
" Grep motion from normal mode
nnoremap <leader>g :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@

nnoremap <Leader>: :Rg<Space>

nnoremap <silent> <Leader>cw  :exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>

" undo git chunk
nnoremap <silent> <leader>u :CocCommand git.chunkUndo<CR>

" explorer
nnoremap <silent> <c-b> :CocCommand explorer<CR>

" display chunkinfo
nnoremap <silent> gs <Plug>(coc-git-chunkinfo)

" navigate conflicts of current buffer
nmap [gc <Plug>(coc-git-prevchunk)
nmap ]gc <Plug>(coc-git-nextchunk)

function! s:GrepFromSelected(type)
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let word = substitute(@@, '\n$', '', 'g')
  let word = escape(word, '| ')
  let @@ = saved_unnamed_register
  execute 'CocList grep '.word
endfunction

" Prettify json with python
command! -nargs=0 JSONPretty %!python3 -m json.tool

if executable("node")
  command! -nargs=0 JSONtoObject  %!node <<< console.dir(JSON.parse(\'$(cat)\'), { depth: null })
  command! -nargs=0 JSONPretty    %!node <<< \"console.log(JSON.stringify($(cat), null, 2))\"<CR>
endif

command! -nargs=0 Todos         CocList -A --normal grep -e TODO|FIXME|FIX|FIXIT|BUG|HACK|XXX
command! -nargs=0 Status        CocList -A --normal gstatus

" use vim like tail => open file and use this command
command! -nargs=0 Tailf execute ":set autoread | au CursorHold * checktime | call feedkeys(\"lh\")"

if executable("code")
  command! -nargs=0 VSCode execute ":!code -g %:p\:" . line('.') . ":" . col('.')
endif

if executable("xxd")
  " file content to hexdump
  command! -nargs=0 HexDump %!xxd
  " reverse
  command! -nargs=0 RHexDump %!xxd -r
endif

" reverse lines of selection
if executable("tail")
  command -range -nargs=0 Reverse <line1>,<line2>!tail -r
endif

" command line mode mappings
cnoremap <C-a> <Home>
cnoremap <C-b> <S-Left>
cnoremap <C-f> <S-Right>
cnoremap <C-h> <S-Left>
cnoremap <C-l> <S-Right>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>
cnoremap <C-n> <C-R>=expand("%:p")<CR>
cnoremap <C-q> <C-\>eDeleteTillSlash()<cr>

cnoreabbrev Blame Git blame
cnoreabbrev Ack! Rg

" press $q in command mode to delete until last slash
cno $q <C-\>eDeleteTillSlash()<cr>

"" Prettier

"Enable auto formatting of files that have "@format" or "@prettier" tag
let g:prettier#autoformat = 0

"Allow auto formatting for files without "@format" or "@prettier" tag
let g:prettier#autoformat_require_pragma = 0

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

vnoremap <silent> <leader>: :call VisualSelection('gv', '')<CR>

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call <SID>GrepFromSelected("v")
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

function! CmdLine(str)
  call feedkeys(":" . a:str)
endfunction

" open files in vim
" vim -p **/*.md
" :tabdo :call SpellNext()
" ]s ]s to navigate
" 1z= to fix
" <leader>tc to close
fun! SpellNext()
    " Go to start of buffer and enable spell checking.
    normal! gg
    set spell

    " Record cursor position.
    let l:pos = getpos('.')

    " Special case: first word is misspelled.
    if spellbadword()[1] isnot# ''
        return
    endif

    " Try to find a misspelled word.
    normal! ]s

    " No more words left if the position is unchanged from last
    " time, so quit Vim.
    if getpos('.') == l:pos
        quit
    endif
endfun

hi SpellBad cterm=underline,bold ctermfg=red

" for example to change lang
":setlocal spelllang=fr_fr
nmap <F6> :setlocal spell!<CR>
nmap <leader>sf 1z=

" autocmd FileType markdown set spell

" Surround-vim addition to delete a function
nmap <silent> dsf ds)db

" Convert slashes to backslashes for Windows.
if has('win32')
  nmap ,cs :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap ,cl :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>

  " This will copy the path in 8.3 short format, for DOS and Windows 9x
  nmap ,c8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>
else
  nmap ,cs :let @+=expand("%:t")<CR>
  nmap ,cps :let @+=expand("%")<CR>
  nmap ,cpl :let @+=expand("%:p")<CR>
  nmap ,cr :let @*=expand("%:p") . ":" . (line(".")+1)<CR>
endif

" file type messages is for highlights when checking logs like in /var/log
nnoremap <Leader>m :set filetype=messages<CR>

" Shortcuts for frequently accessed files
command! Vimrc e ~/dotfiles/vim/vimrc.symlink
command! Zshrc e ~/dotfiles/oh-my-zsh/zshrc.symlink
command! Gitconfig e ~/.gitconfig

"debugger
let g:vimspector_enable_mappings = 'HUMAN'

let g:markdown_fenced_languages = ['python', 'javascript', 'json', 'bash', 'typescript', 'html']

" rainbow parentheses
let g:rainbow_active = 0 "set to 0 if you want to enable it later via :RainbowToggle

let g:rainbow_conf = {
      \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
      \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
      \   'guis': [''],
      \   'cterms': [''],
      \   'operators': '_,_',
      \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \   'separately': {
      \      '*': {},
      \      'javascript': {
      \         'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
      \      },
      \      'typescript': {
      \         'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
      \      },
      \      'vue': {
      \         'parentheses': ['start=/{/ end=/}/ contains=@javaScript containedin=@javaScript',
      \             'start=/(/ end=/)/ contains=@javaScript containedin=@javaScript',
      \             'start=/[/ end=/]/ contains=@javaScript containedin=@javaScript',
      \             'start=/{/ end=/}/ contains=@javaScript containedin=@javaScript',
      \             'start=/(/ end=/)/ contains=@typeScript containedin=@typeScript',
      \             'start=/[/ end=/]/ contains=@typeScript containedin=@typeScript',
      \             'start=/\v\<((script|style|area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
      \      },
      \      'css': 0,
      \   }
      \}

" Go
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_functions_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1

" Astro
let g:astro_typescript = 'enable'

" abbreviations
" insert current date/time
" iabbrev <expr> ddd strftime('%d/%m/%y %H:%M:%S')
iabbrev <expr> ddd strftime('%Y-%m-%dT%H:%M:%SZ')
iabbrev #i #include
iabbrev #d #define

"shortcuts for parenthesis etc
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $$ ""<esc>i
inoremap $e ``<esc>i
inoremap $t <><esc>i

"visual mode surround
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a`<esc>`<i`<esc>

" escape insert mode
inoremap jj <esc>
inoremap hh <esc>

" fix gx for opening url
" nmap gx yiW:!open <cWORD><CR> <C-r>" & <CR><CR>
" vnoremap gx // :!open <C-r>" & <CR><CR>

" open notes
noremap <leader>en :edit ~/dev/notes/README.adoc<CR>

" copy current filname:line number into clipboard, then use gF to open the ref
noremap <leader>er :let @*=expand("%:p") . ":" . (line(".")+1)<CR>

"sideways.vim conf
" alt + h or alt + l to move arg left or right
nnoremap <M-h> :SidewaysLeft<CR>
nnoremap <M-l> :SidewaysRight<CR>

" argument text object
" for example 'daa' delete an argument
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

" Move a line of text using ALT+[jk]
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`zd
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

function! OpenLog()
  let line = getline(".")
  let items = split(line, ':')
  if filereadable(items[0])
    tabnew
    exe "e ".items[0]
    exe ":".items[1]
  endif
endfunction

" asciidoc
" automaticaly generate html on save
" augroup ON_ASCIIDOCTOR_SAVE | au!
"     au BufWritePost *.adoc :Asciidoctor2HTML
" augroup end

let g:asciidoctor_opener='open'

func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc


" close buffer
map <leader>bd :bd<cr>
" close all buffers
" map <leader>ba :bufdo bd!<cr>
map <leader>ba :%bw<cr>

" switch cwd to open buffer dir
map <leader>cd :cd %:p:h<cr>:pwd<cr>

function! DeleteDuplicateLines() range
  let lineCounts = {}
  let lineNum = a:firstline
  while lineNum <= a:lastline
    let lineText = getline(lineNum)
    if lineText != ""
        if has_key(lineCounts, lineText)
            execute lineNum . 'delete _'
            if lineCounts[lineText] > 0
              execute lineCounts[lineText] . 'delete _'
              let lineCounts[lineText] = 0
              let lineNum -= 1
            endif
        else
            let lineCounts[lineText] =  lineNum
            let lineNum += 1
        endif
    else
      let lineNum += 1
    endif
  endwhile
endfunction

command! -range=% DeleteDuplicateLines <line1>,<line2>call DeleteDuplicateLines()

function! HandleURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;()]*')
  let s:uri = split(s:uri, '[')[0]
  let s:uri = shellescape(s:uri, 1)
  echom s:uri
  if s:uri != ""
    silent exec "!open ".s:uri
    :redraw!
  else
    echo "No URI found in line."
  endif
endfunction

nnoremap gx :call HandleURL()<CR>

nnoremap dn ]c
nnoremap dN [c

" Effective editing of multiple files in Vim
" https://jovica.org/posts/vim-edit-multiple-files/
"
" list all files with Bad in it and put in in args
" :args `=systemlist("git grep -l Bad")`
" :argdo %s/\CBad/\CGood/ge | update

command! -nargs=1 ArgsGrepPopulate exe 'args `rg -l '.<f-args>. '`'

" to show some stats about the current file, like the file size press g<C-g>
command! -nargs=0 FileStats exe 'normal g<C-g>'

function Gitdiff(...)
  let revision = a:0 == 1 ? a:1 : 'HEAD~0'

  let s:filename = system('git rev-parse --show-prefix | tr -d "\n"') .  expand('%')
  set nofoldenable
  vert new
  set bt=nofile

  let s:cmd = 'git show '. revision .':' . s:filename
  let @"=system(s:cmd)

  exec 'normal ""PGdd'
  diffthis
  wincmd p
  diffthis
endfunction

command! -nargs=? Gitdiff call Gitdiff(<f-args>)

command! -nargs=0 GeneratePassword exe 'r !gpass'

" exemple de regex pour matcher interface (ITestInterface) {
" ou interface (ITest) extends {
"
" \(interface \)\@<=\(\w*\)\(\s\)\@=
" \@<= : match apres le token
" \@=  : no match apres le token et sur le token
"
" copier tous les resultats d'une regex dans une variable t
"
" :let t=[] | %s/\(interface \)\@<=\(\w*\)\(\s\)\@=/\=add(t,submatch(2))[len(t)-1]/g
"
" dans la partie replace on va executer une commande \=add() pour ajouter le
" match a t
" submatch(2) car ce qui nous interesse est le 2eme objet matché (ce quil y a
" entre 'interface ' et ' {'
" ensuite on pointe sur l'index de t [len(t) - 1] pour remplacer par le match
" que l'on vient de retirer comme ça le fichier ne bouge pas
" maintenant pour coller le contenu de la variable t on peut faire
"
" "=tp
" ou encore :pu=t
" ou encore :pu=join(t, ', ')
"
" autre exemple
"
" :let t=[] | %s/\<case\s\+\(\w\+\):\zs/\=add(t,submatch(1))[1:0]/g
"
" :g and :v permets de selectionner des lignes, g pour inclure v pour exclure
" la commande a appliquer peut etre nimporte quoi.. par exemple
"
" :g/-/norm @a pour appliquer la macro a aux lignes contenant -
"
" ou
"
" :v/-/s/word/newword pour remplacer word par newword sur toutes les lignes
" qui ne contiennent pas -
"
" :g/include/command
" :v/exclude/command
"
" command peut etre t0 ou t$ pour copier ces lignes la ou est le cursor

" Bulk rename file
" :h rename-files
" 1. :r !ls foo
" 2. :%s/.*/mv & &/
" 3. :w !zsh

" Select all matches into one buffer
" This can be simply achieved, by running a :s command with the n flag set (which
" basically says, to not replace anything (but by using an \= in the replace part,
" you can still capture the matches (see :h sub-replace-special).
" So first let's clear register A:
" qaq
" Then you can capture your maches into register a by using:
" :%s/'user': '[a-Z]*'/\=setreg('A', submatch(0), 'V')/gn
" And paste your matches:
" :put A

" Cancel COMMIT_EDITMSG
" quit vim with an error using :cq
