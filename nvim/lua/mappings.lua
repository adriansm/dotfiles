--
-- Map Helpers
--

local keymap = require('common').set_keymap

function imap(shortcut, command)
  keymap('i', shortcut, command)
end

function nmap(shortcut, command)
  keymap('n', shortcut, command)
end

function tmap(shortcut, command)
  keymap('t', shortcut, command)
end

function map(shortcut, command, opts)
  require('common').nvim_set_keymap('', shortcut, command, opts)
end

-- Easily split windows
map('<Space>', '<Leader>', {})

nmap("<C-W>\\|", "<cmd>vsplit<CR>")
nmap("<C-W>-", "<cmd>split<CR>")

-- File Explorer
nmap(';e', '<cmd>NvimTreeToggle<CR>')
nmap('<leader>e', '<cmd>NvimTreeToggle<CR>')
-- nnoremap <leader>r :NvimTreeRefresh<CR>
-- nnoremap <leader>n :NvimTreeFindFile<CR>

-- Find files using Telescope command-line sugar.
nmap('<leader>ff', '<cmd>Telescope find_files<cr>')
nmap('<leader>fg', '<cmd>Telescope live_grep<cr>')
nmap('<leader>fb', '<cmd>Telescope buffers<cr>')
nmap('<leader>fh', '<cmd>Telescope help_tags<cr>')

nmap(';;', '<cmd>Telescope buffers<cr>')
nmap(';p', '<cmd>Telescope git_files<cr>')
nmap(';o', '<cmd>Telescope git_files use_git_root=false<cr>')
nmap(';h', '<cmd>Telescope help_tags<cr>')
nmap(';g', '<cmd>Telescope live_grep<cr>')
nmap(';r', '<cmd>Telescope grep_string<cr>')

nmap('<leader>b', '<cmd>Telescope buffers<cr>')
nmap('<leader>p', '<cmd>Telescope git_files<cr>')
nmap('<leader>o', '<cmd>Telescope git_files use_git_root=false<cr>')

-- Terminal options
tmap('<Esc>', '<C-\\><C-n>')
tmap('<C-h>', '<C-\\><C-N><cmd>TmuxNavigateLeft<cr>')
tmap('<C-j>', '<C-\\><C-N><cmd>TmuxNavigateDown<cr>')
tmap('<C-k>', '<C-\\><C-N><cmd>TmuxNavigateUp<cr>')
tmap('<C-l>', '<C-\\><C-N><cmd>TmuxNavigateRight<cr>')

vim.cmd[[autocmd TermOpen * setlocal nonumber norelativenumber]]
