-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- to show documentation of something under the cursor
-- press <S-K>

-- Shortcuts for frequently accessed files
vim.cmd(
  "command! Vimrc e ~/dotfiles/vim/vimrc.symlink"
)
vim.cmd(
  "command! Zshrc e ~/dotfiles/oh-my-zsh/zshrc.symlink"
)
vim.cmd(
  "command! Gitconfig e ~/.gitconfig"
)

-- generate password
vim.cmd(
  'command! -nargs=0 GeneratePassword exe "r !gpass"'
)

-- show some stats about the file
vim.cmd(
  'command! -nargs=0 FileStats exe "normal! g<C-g>"'
)

-- format current buffer using command :Format
vim.cmd(
  [[
  command! -nargs=0 Format exe 'normal! gg=G'
]]
)

-- JSON
vim.cmd(
  [[
  command! -nargs=0 JSONPretty %!python3 -m json.tool
]]
)

if
  vim.fn.executable(
    "node"
  )
  == 1
then
  vim.cmd(
    [[
    command! -nargs=0 JSONtoObject %!node <<< console.dir(JSON.parse('$(cat)'), { depth: null })
    command! -nargs=0 JSONPretty %!node <<< "console.log(JSON.stringify($(cat), null, 2))"<CR>
  ]]
  )
end

-- use vim like tail, open file and use :Tail
vim.cmd(
  [[
  command! -nargs=0 Tailf execute ":set autoread | au CursorHold * checktime | call feedkeys(\"lh\")"
]]
)

-- open in VSCode
if
  vim.fn.executable(
    "code"
  )
  == 1
then
  vim.cmd(
    [[
    command! -nargs=0 Code execute ":!code -g %:p:" . line('.') . ":" . col('.')
  ]]
  )
end

-- Hexdump
if
  vim.fn.executable(
    "xxd"
  )
  == 1
then
  vim.cmd(
    [[
    " file content to hexdump
    command! -nargs=0 HexDump %!xxd
    " reverse
    command! -nargs=0 RHexDump %!xxd -r
  ]]
  )
end

if
  vim.fn.executable(
    "tail"
  )
  == 1
then
  vim.cmd(
    [[
    " reverse lines of selection
    command! -range -nargs=0 Reverse <line1>,<line2>!tail -r
  ]]
  )
end

-- Press <Enter> in normal mode to remove highlights (search results)
vim.keymap.set(
  "n",
  "<cr>",
  ":noh<cr>",
  {
    silent = true,
  }
)

-- put search results in the middle of the screen
vim.keymap.set(
  "n",
  "n",
  "nzz"
)
vim.keymap.set(
  "n",
  "N",
  "Nzz"
)

-- navigate tabs with alt + arrows
vim.keymap.set(
  "n",
  "<M-Left>",
  ":tabprevious<CR>",
  {
    noremap = true,
    silent = true,
  }
)
vim.keymap.set(
  "n",
  "<M-Right>",
  ":tabnext<CR>",
  {
    noremap = true,
    silent = true,
  }
)

-- redo
vim.keymap.set(
  "n",
  "U",
  ":redo<CR>",
  {
    noremap = true,
    silent = true,
  }
)

-- avoid arrow naw
vim.keymap.set(
  "n",
  "<Left>",
  ':echoe "Use h"<CR>',
  {
    noremap = true,
    silent = true,
  }
)
vim.keymap.set(
  "n",
  "<Right>",
  ':echoe "Use l"<CR>',
  {
    noremap = true,
    silent = true,
  }
)
vim.keymap.set(
  "n",
  "<Up>",
  ':echoe "Use k"<CR>',
  {
    noremap = true,
    silent = true,
  }
)
vim.keymap.set(
  "n",
  "<Down>",
  ':echoe "Use j"<CR>',
  {
    noremap = true,
    silent = true,
  }
)

-- Command line typing nav
vim.api.nvim_set_keymap(
  "c",
  "<C-a>",
  "<Home>",
  {
    noremap = true,
    silent = true,
  }
)
vim.api.nvim_set_keymap(
  "c",
  "<C-b>",
  "<S-Left>",
  {
    noremap = true,
    silent = true,
  }
)
vim.api.nvim_set_keymap(
  "c",
  "<C-f>",
  "<S-Right>",
  {
    noremap = true,
    silent = true,
  }
)
vim.api.nvim_set_keymap(
  "c",
  "<C-h>",
  "<S-Left>",
  {
    noremap = true,
    silent = true,
  }
)
vim.api.nvim_set_keymap(
  "c",
  "<C-l>",
  "<S-Right>",
  {
    noremap = true,
    silent = true,
  }
)
vim.api.nvim_set_keymap(
  "c",
  "<C-e>",
  "<End>",
  {
    noremap = true,
    silent = true,
  }
)
vim.api.nvim_set_keymap(
  "c",
  "<C-d>",
  "<Del>",
  {
    noremap = true,
    silent = true,
  }
)
vim.api.nvim_set_keymap(
  "c",
  "<C-t>",
  '"" .. expand("%:p:h") .. "/"',
  {
    noremap = true,
    silent = true,
    expr = true,
  }
)

vim.api.nvim_set_keymap(
  "c",
  "<C-n>",
  '"" .. expand("%:p")',
  {
    noremap = true,
    silent = true,
    expr = true,
  }
)

-- copy filepath
if
  vim.fn.has(
    "win32"
  )
  == 1
then
  vim.keymap.set(
    "n",
    ",cs",
    ':let @*=substitute(expand("%"), "/", "\\", "g")<cr>',
    {
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    ",cl",
    ':let @*=substitute(expand("%:p"), "/", "\\", "g")<cr>',
    {
      silent = true,
    }
  )
  -- this will copy the path in 8.3 short format, for dos and windows 9x
  vim.keymap.set(
    "n",
    ",c8",
    ':let @*=substitute(expand("%:p:8"), "/", "\\", "g")<cr>',
    {
      silent = true,
    }
  )
else
  vim.keymap.set(
    "n",
    ",cs",
    ':let @+=expand("%:t")<cr>',
    {
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    ",cps",
    ':let @+=expand("%")<cr>',
    {
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    ",cpl",
    ':let @+=expand("%:p")<cr>',
    {
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    ",cr",
    ':let @*=expand("%:p") .. ":" .. (line(".") + 1)<cr>',
    {
      silent = true,
    }
  )
end

-- Surround-vim addition to delete a function
vim.keymap.set(
  "n",
  "dsf",
  "ds)db",
  {
    silent = true,
  }
)
--
-- file type messages is for highlights when checking logs like in /var/log
vim.keymap.set(
  "n",
  "<Leader>m",
  ":set filetype=messages<CR>",
  {
    silent = true,
  }
)

-- shortcuts for parenthesis etc
vim.keymap.set(
  "i",
  "$1",
  "()<esc>i",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "i",
  "$2",
  "[]<esc>i",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "i",
  "$3",
  "{}<esc>i",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "i",
  "$4",
  "{<esc>o}<esc>O",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "i",
  "$q",
  "''<esc>i",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "i",
  "$$",
  '""<esc>i',
  {
    noremap = true,
  }
)
vim.keymap.set(
  "i",
  "$e",
  "``<esc>i",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "i",
  "$t",
  "<><esc>i",
  {
    noremap = true,
  }
)

-- visual mode surround
vim.keymap.set(
  "v",
  "$1",
  "<esc>`>a)<esc>`<i(",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "v",
  "$2",
  "<esc>`>a]<esc>`<i[",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "v",
  "$3",
  "<esc>`>a}<esc>`<i{",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "v",
  "$$",
  '<esc>`>a"<esc>`<i"',
  {
    noremap = true,
  }
)
vim.keymap.set(
  "v",
  "$q",
  "<esc>`>a'<esc>`<i'",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "v",
  "$e",
  "<esc>`>a`<esc>`<i`",
  {
    noremap = true,
  }
)

-- escape insert mode
vim.keymap.set(
  "i",
  "jj",
  "<esc>",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "i",
  "hh",
  "<esc>",
  {
    noremap = true,
  }
)

-- sideways.vim conf
-- alt + h or alt + l to move arg left or right
vim.keymap.set(
  "n",
  "<M-h>",
  ":SidewaysLeft<CR>",
  {
    noremap = true,
    silent = true,
  }
)
vim.keymap.set(
  "n",
  "<M-l>",
  ":SidewaysRight<CR>",
  {
    noremap = true,
    silent = true,
  }
)

-- argument text object
-- for example 'daa' delete an argument
vim.keymap.set(
  "o",
  "aa",
  "<Plug>SidewaysArgumentTextobjA",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "x",
  "aa",
  "<Plug>SidewaysArgumentTextobjA",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "o",
  "ia",
  "<Plug>SidewaysArgumentTextobjI",
  {
    noremap = true,
  }
)
vim.keymap.set(
  "x",
  "ia",
  "<Plug>SidewaysArgumentTextobjI",
  {
    noremap = true,
  }
)

-- Move a line of text using ALT+[jk] doesnt seems to work, to investigate
vim.keymap.set(
  "n",
  "<M-j>",
  "mz:m+<cr>`z",
  {
    silent = true,
  }
)
vim.keymap.set(
  "n",
  "<M-k>",
  "mz:m-2<cr>`zd",
  {
    silent = true,
  }
)
vim.keymap.set(
  "v",
  "<M-j>",
  ":m'>+<cr>`<my`>mzgv`yo`z",
  {
    noremap = true,
    silent = true,
  }
)
vim.keymap.set(
  "v",
  "<M-k>",
  ":m'<-2<cr>`>my`<mzgv`yo`z",
  {
    noremap = true,
    silent = true,
  }
)

-- set cwd to current buffer dir
vim.keymap.set(
  "n",
  "<leader>wd",
  ":cd %:p:h<cr>:pwd<cr>",
  {
    noremap = true,
    silent = true,
  }
)

-- rebind alt key modifier
-- the bind can depends from terminal emulators,
-- to get the character that the bind produce you must
-- go in insert mode and press ctrl-v and then the keybind
-- for example now ctrl-v alt-j produces ∆
-- to investigate
if
  vim.fn.has(
      "mac"
    )
    == 1
  or vim.fn.has(
      "macunix"
    )
    == 1
then
  vim.keymap.set(
    "n",
    "Ï",
    "<M-j>",
    {
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "È",
    "<M-k>",
    {
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "Ì",
    "<M-h>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "¬",
    "<M-l>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "∆",
    "<M-j>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "˚",
    "<M-k>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "˙",
    "<M-h>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "å",
    "<M-a>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "∑",
    "<M-w>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "ç",
    "<M-c>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "ø",
    "<M-o>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "ß",
    "<M-s>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "≤",
    "<M-,>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "…",
    "<M-;>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "π",
    "<M-p>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "ƒ",
    "<M-f>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "˙",
    "<M-h>",
    {
      noremap = true,
      silent = true,
    }
  ) -- Duplicate mapping
  vim.keymap.set(
    "n",
    "ω",
    "<M-z>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "n",
    "≈",
    "<M-x>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "å",
    "<M-a>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "∑",
    "<M-w>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "Ï",
    "<M-j>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "È",
    "<M-k>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "Ì",
    "<M-h>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "¬",
    "<M-l>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "∆",
    "<M-j>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "˚",
    "<M-k>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "˙",
    "<M-h>",
    {
      noremap = true,
      silent = true,
    }
  ) -- Duplicate mapping
  vim.keymap.set(
    "v",
    "ç",
    "<M-c>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "ø",
    "<M-o>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "ß",
    "<M-s>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "≤",
    "<M-,>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "…",
    "<M-;>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "π",
    "<M-p>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "ƒ",
    "<M-f>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "˙",
    "<M-h>",
    {
      noremap = true,
      silent = true,
    }
  ) -- Duplicate mapping
  vim.keymap.set(
    "v",
    "ω",
    "<M-z>",
    {
      noremap = true,
      silent = true,
    }
  )
  vim.keymap.set(
    "v",
    "≈",
    "<M-x>",
    {
      noremap = true,
      silent = true,
    }
  )
end
