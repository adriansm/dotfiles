local M = {}

---@class Config
local defaults = {
  colorscheme = "vscode"
}

local options

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})

  M.load("autocmds")
  M.load("keymaps")

  require("lazy.core.util").try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      require("lazy.core.util").error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local Util = require("lazy.core.util")
  -- always load lazyvim, then user file
  local mod = "config." .. name
  Util.try(function()
    require(mod)
  end, {
    msg = "Failed loading " .. mod,
    on_error = function(msg)
      local modpath = require("lazy.core.cache").find(mod)
      if modpath then
        Util.error(msg)
      end
    end,
  })
end

M.did_init = false
function M.init()
  if not M.did_init then
    M.did_init = true

    -- load options here, before lazy init while sourcing plugin modules
    -- this is needed to make sure options will be correctly applied
    -- after installing missing plugins
    require("config").load("options")
  end
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    ---@cast options Config
    return options[key]
  end,
})

return M
