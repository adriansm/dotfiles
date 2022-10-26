local M = {}

local nls = require('null-ls')
local b = nls.builtins

local sources = {
  -- formatting
  b.formatting.shfmt,
  b.formatting.fixjson,
  b.formatting.stylua,

  -- diagnostics
  b.diagnostics.shellcheck,

  -- code actions
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,

  -- hover
  b.hover.dictionary,
}

function M.setup(opts)
  nls.setup({
    on_init = function(new_client, _)
      new_client.offset_encoding = 'utf-8'
    end,
    sources = sources,
    on_attach = opts.on_attach,
  })
end

return M
