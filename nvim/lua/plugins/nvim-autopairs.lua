local status_ok, nvim_autopairs = pcall(require, "nvim-autopairs")
if not status_ok then
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

local status_ok, cmp = pcall(require, "cmp")
if status_ok then
  -- register completion event
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')

  cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
end
