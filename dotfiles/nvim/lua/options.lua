-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Highlight code found in markdown files
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

-- disable perl and ruby default providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Highlight embedded languages in the strings
-- in lua, python, and javascript
vim.g.vimsyn_embed = "lPj"

-- Enable truecolor
vim.opt.termguicolors = true

-- Enable dark mode
vim.opt.background = "dark"

-- Make line numbers relative
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = "ar"

-- Increase max memory for pattern matching
vim.opt.maxmempattern = 4000

-- Layout for default ruler
vim.opt.rulerformat = "%30(%=\\ :b%n%y%m%r%w \\ %l,%c%V \\ %P%)"

-- Set window title based on file
vim.opt.title = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Use system clipboard
vim.opt.clipboard = "unnamed"

-- CD to home when called without args
vim.opt.cdhome = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Allow smart case for tags
vim.opt.tagcase = "followscs"

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Enable code folding powered by treesitter
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"

-- Syntax highlight first line of fold
vim.opt.foldtext = ""

-- Don't auto-fold
vim.opt.foldlevel = 99

-- Don't fold after 4 levels
vim.opt.foldnestmax = 4

-- Indicate line break
vim.opt.showbreak = "+++ "

-- Break lines at word boundaries
vim.opt.linebreak = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live
vim.opt.inccommand = "split"
vim.opt.incsearch = true

-- Show which line your cursor is on
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Scroll the screen instead of cursor on limit
vim.opt.scrolloff = 10

-- Auto-save file on focus change
vim.opt.autowrite = true
vim.opt.autoread = true

-- Indenting
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

--  Replace end of file ~ with nothing
vim.opt.fillchars:append(",eob: ")

-- Disable nvim intro and search messages
vim.opt.shortmess:append("sI")

-- Configure how backspace works
vim.opt.backspace = "indent,eol,start,nostop"

-- Confirm before abandoning unsaved changes
vim.opt.confirm = true

-- Show extra info in autocomplete
vim.opt.showfulltag = true

-- Smooth scroll wrapped lines
vim.opt.smoothscroll = true

-- Spell check camel-cased words
vim.opt.spelloptions = "camel"

vim.opt.matchpairs:append("<:>,「:」,『:』,【:】,“:”,‘:’,《:》")

vim.opt.tildeop = true

vim.opt.completeopt:append("menuone")

vim.opt.colorcolumn = "80"
