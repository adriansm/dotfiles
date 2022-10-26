local M = {}

local prequire = require('utils.common').prequire

function M.setup()
  local nvim_autopairs = prequire('nvim-autopairs')
  if not nvim_autopairs then
    return
  end

  nvim_autopairs.setup({
    check_ts = true,
    ts_config = {
      lua = {'string'},  -- it will not add a pair on that treesitter node
      javascript = {'template_string'},
      java = false -- don't check treesitter on java
    }
  })

  local cmp = prequire('cmp')
  if cmp then
    -- register completion event
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
  end
end

return M
