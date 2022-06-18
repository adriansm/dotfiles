local M = {}

--
-- Map Helpers
--

-- local keymap = require('common').set_keymap
local keymap = require('utils.keymap')

local keymappings = {
  normal_mode = {
    -- Easily split windows
    ["<C-W>|"] = "<cmd>vsplit<CR>",
    ["<C-W>-"] = "<cmd>split<CR>",

    -- File Explorer
    [';e'] = '<cmd>NvimTreeToggle<CR>',
    ['<leader>e'] = '<cmd>NvimTreeToggle<CR>',

    -- nnoremap <leader>r :NvimTreeRefresh<CR>
    -- nnoremap <leader>n :NvimTreeFindFile<CR>

    -- Find files using Telescope command-line sugar.
    ['<leader>ff'] = '<cmd>Telescope find_files<cr>',
    ['<leader>fg'] = '<cmd>Telescope live_grep<cr>',
    ['<leader>fb'] = '<cmd>Telescope buffers<cr>',
    ['<leader>fh'] = '<cmd>Telescope help_tags<cr>',

    [';;'] = '<cmd>Telescope buffers<cr>',
    [';p'] = '<cmd>Telescope git_files<cr>',
    [';o'] = '<cmd>Telescope git_files use_git_root=false<cr>',
    [';h'] = '<cmd>Telescope help_tags<cr>',
    [';g'] = '<cmd>Telescope live_grep<cr>',
    [';r'] = '<cmd>Telescope grep_string<cr>',

    ['<leader>b'] = '<cmd>Telescope buffers<cr>',
    ['<leader>p'] = '<cmd>Telescope git_files<cr>',
    ['<leader>o'] = '<cmd>Telescope git_files use_git_root=false<cr>',
  },
  term_mode = {
    ['<Esc>'] = '<C-\\><C-n>',
    -- Integrate with tmux navigator
    ['<C-h>'] = '<C-\\><C-N><cmd>TmuxNavigateLeft<cr>',
    ['<C-j>'] = '<C-\\><C-N><cmd>TmuxNavigateDown<cr>',
    ['<C-k>'] = '<C-\\><C-N><cmd>TmuxNavigateUp<cr>',
    ['<C-l>'] = '<C-\\><C-N><cmd>TmuxNavigateRight<cr>',
  },
  command_mode = {
    ["<C-j>"] = {
      'pumvisible() ? "\\<C-n>" : "\\<C-j>"',
      { expr = true, noremap = true },
    },
    ["<C-k>"] = {
      'pumvisible() ? "\\<C-p>" : "\\<C-k>"',
      { expr = true, noremap = true },
    },
    ["w!!"] = "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!",
    ["%%"] = { "getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'", { expr = true, noremap = true } },
    ["%H"] = { "<C-R>=expand('%:h:p') . std#path#separator()<CR>", { expr = false, noremap = true } },
    ["%T"] = { "<C-R>=expand('%:t')<CR>", { expr = false, noremap = true } },
    ["%P"] = { "<C-R>=expand('%:p')<CR>", { expr = false, noremap = true } },
  }
}

function M.setup()
  for mode, mapping in pairs(keymappings) do
    keymap.map(mode, mapping)
  end

  vim.api.nvim_set_keymap('', '<space>', '<leader>', {})

  -- Terminal options

  vim.cmd[[autocmd TermOpen * setlocal nonumber norelativenumber]]
end

return M
