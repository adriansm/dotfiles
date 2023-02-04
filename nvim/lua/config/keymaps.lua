--
-- Map Helpers
--

-- local keymap = require('common').set_keymap
local keymap = require('utils.keymap')

local keymappings = {
  normal_mode = {
    -- Easily split windows
    ['<C-W>|'] = '<cmd>vsplit<CR>',
    ['<C-W>-'] = '<cmd>split<CR>',
  },
  term_mode = {
    ['<Esc>'] = '<C-\\><C-n>',
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
    ["%%"] = { "getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'", { expr = true, noremap = true } },
    ["%H"] = { "<C-R>=expand('%:h:p') . std#path#separator()<CR>", { expr = false, noremap = true } },
    ["%T"] = { "<C-R>=expand('%:t')<CR>", { expr = false, noremap = true } },
    ["%P"] = { "<C-R>=expand('%:p')<CR>", { expr = false, noremap = true } },
  }
}

for mode, mapping in pairs(keymappings) do
  keymap.map(mode, mapping)
end

vim.cmd[[cmap w!! w !sudo tee > /dev/null %]]
vim.api.nvim_set_keymap('', '<space>', '<leader>', {})
