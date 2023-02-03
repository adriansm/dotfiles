local M = {}

local prequire = require('utils.common').prequire

function M.setup()
  local configs = prequire('nvim-treesitter.configs')
  if not configs then
    return
  end

  configs.setup {
    highlight = {
      enable = true,
      disable = {},
    },
    indent = {
      enable = false,
      disable = {},
    },
    ensure_installed = {
      "c",
      "cpp",
      "lua",
      "vim",
      "help",
      "python",
      "toml",
      "json",
      "yaml",
      "html"
    },
  }
end

return M
