local M = {}

local prequire = require('utils.common').prequire
local keymap = require('utils.keymap')

local function onAttach(bufnr)
  local gs = package.loaded.gitsigns

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
  map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

  -- Actions
  map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
  map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
  map('n', '<leader>hS', gs.stage_buffer)
  map('n', '<leader>hu', gs.undo_stage_hunk)
  map('n', '<leader>hR', gs.reset_buffer)
  map('n', '<leader>hp', gs.preview_hunk)
  map('n', '<leader>hb', function() gs.blame_line{full=true} end)
  map('n', '<leader>tb', gs.toggle_current_line_blame)
  map('n', '<leader>hd', gs.diffthis)
  map('n', '<leader>hD', function() gs.diffthis('~') end)
  map('n', '<leader>td', gs.toggle_deleted)
end

function M.setup()
  local gitsigns = prequire('gitsigns')
  if not gitsigns then
    return
  end
  local opts = {
    on_attach = onAttach
  }

  gitsigns.setup(opts)
end

return M
