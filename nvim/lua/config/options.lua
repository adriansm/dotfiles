local set_options = require('utils.common').set_options
local cmd = vim.api.nvim_command

-- vim.opt.listchars.tab = "\\u2192"
-- vim.opt.listchars.trail = "\\u2022"
-- vim.opt.listchars.extends = "\\u27E9"
-- vim.opt.listchars.precedes = "\\u27E8"
-- List chars
cmd[[
  let &listchars="tab:\u2192 ,trail:\u2022,extends:\u27E9,precedes:\u27E8"
  let &showbreak="\u21aa "
]]

local opt = vim.opt

opt.autoread = true         -- re-read file if change was detected outside of vim
opt.autowrite = true        -- Enable auto write
opt.backup = false          -- do not backup files
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.cmdheight = 2           -- Better display for messages
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.encoding = "utf-8"
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.foldmethod = "marker"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.gdefault = true         -- Subsitute all matches by default
opt.hidden = true           -- TextEdit might fail if hidden is not set
opt.hlsearch = true         -- Highlight search match
opt.history = 50
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.incsearch = true        -- Incremental search
opt.laststatus = 0
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append { W = true, I = true, c = true }
opt.showcmd = true          -- Show (partial) command in status line.
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.swapfile = false        -- do not write swap files
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.visualbell = true       -- use visual bell instead of beeping
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.whichwrap = 'h,l,~,[,]'
opt.wrap = false -- Disable line wrap
opt.writebackup = false     -- do not write backup files
