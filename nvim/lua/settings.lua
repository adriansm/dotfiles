local set_options = require('common').set_options

vim.opt.listchars.tab = "\\u2192"
vim.opt.listchars.trail = "\\u2022"
vim.opt.listchars.extends = "\\u27E9"
vim.opt.listchars.precedes = "\\u27E8"

vim.opt.shortmess:append({ c = true })   -- don't give |ins-completion-menu| messages.
vim.opt.completeopt = { "menuone", "noselect" }, -- mostly just for cmp

set_options({
  --
  -- Editor options
  --
  number = true,           -- show line numbers
  relativenumber = true,   -- relative line numbers
  cursorline = true,       -- Show cursor line

  showbreak = "\\u21aa ",

  foldmethod = "marker",
  encoding = "UTF-8",

  wrap = false,            -- Do not wrap words (view)
  whichwrap = 'h,l,~,[,]',

  shiftwidth = 2,
  shiftround = true,
  tabstop = 2,
  expandtab = true,

  --
  -- Search
  --
  gdefault = true,         -- Subsitute all matches by default
  incsearch = true,        -- Incremental search
  hlsearch = true,         -- Highlight search match
  ignorecase = true,       -- Do case insensitive matching
  smartcase = true,        -- do not ignore if search pattern has CAPS

  --
  -- Status Line
  --
  showcmd = true,          -- Show (partial) command in status line.
  cmdheight = 2,           -- Better display for messages

  --
  -- Misc
  --
  updatetime=300,          -- Bad experience for diagnostic messages when it's default 4000.
  visualbell = true,       -- use visual bell instead of beeping
  hidden = true,           -- TextEdit might fail if hidden is not set

  backup = false,          -- do not backup files
  writebackup = false,     -- do not write backup files
  swapfile = false,        -- do not write swap files
  autoread = true,         -- re-read file if change was detected outside of vim

  history = 50,
  termguicolors = true,
  mouse = 'a',
})
