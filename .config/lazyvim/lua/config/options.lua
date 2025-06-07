-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.lsp.enable(
  "astro"
)

-- remove unwanted files from autocompletion
vim.opt.wildignore:append({
  "*.o",
  "*.obj",
  "*~",
  "*.exe",
  "*.a",
  "*.pdb",
  "*.lib",
  "*.so",
  "*.dll",
  "*.swp",
  "*.egg",
  "*.jar",
  "*.class",
  "*.pyc",
  "*.pyo",
  "*.bin",
  "*.dex",
  "*.log",
  "*.pyc",
  "*.sqlite",
  "*.sqlite3",
  "*.min.js",
  "*.min.css",
  "*.tags",
  "*.zip",
  "*.7z",
  "*.rar",
  "*.gz",
  "*.tar",
  "*.gzip",
  "*.bz2",
  "*.tgz",
  "*.xz",
  "*.png",
  "*.jpg",
  "*.gif",
  "*.bmp",
  "*.tga",
  "*.pcx",
  "*.ppm",
  "*.img",
  "*.iso",
  "*.pdf",
  "*.dmg",
  "*.app",
  "*.ipa",
  "*.apk",
  "*.mobi",
  "*.epub",
  "*.mp4",
  "*.avi",
  "*.flv",
  "*.mov",
  "*.mkv",
  "*.swf",
  "*.swc",
  "*.ppt",
  "*.pptx",
  "*.doc",
  "*.docx",
  "*.xlt",
  "*.xls",
  "*.xlsx",
  "*.odt",
  "*.wps",
  "*/.git/*",
  "*/.svn/*",
  "*.DS_Store",
  "*/node_modules/*",
  "*/nginx_runtime/*",
  "*/build/*",
  "*/logs/*",
  "*/dist/*",
  "*/tmp/*",
})

-- persist undo
vim.opt.undodir =
    vim.fn.expand(
      "~/.config/lazyvim/.undo/"
    )
vim.opt.undofile =
    true
vim.opt.undolevels =
    1000
vim.opt.undoreload =
    10000

-- prevent bug where nvim is hanging from polling clipboard
-- when over ssh
-- use Ctrl + Shift + V to paste
vim.o.clipboard = "unnamedplus"

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}
