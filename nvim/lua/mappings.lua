--
-- Map Helpers
--

local map = require('common').set_keymap

function imap(shortcut, command)
  map('i', shortcut, command)
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

-- Easily split windows

nmap("<C-W>\\|", "<cmd>vsplit<CR>")
nmap("<C-W>-", "<cmd>split<CR>")

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
