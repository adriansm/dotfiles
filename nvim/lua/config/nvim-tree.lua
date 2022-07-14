local M = {}

local prequire = require('utils.common').prequire

function M.setup()
  local nvim_tree = prequire('nvim-tree')
  if not nvim_tree then
    return
  end

  nvim_tree.setup{
    renderer = {
      icons = {
        glyphs = {
          default = '',
          symlink = '',
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "凜",
            untracked = "",
            deleted = "",
            ignored = "◌"
          },
          folder = {
            arrow_open = "",
            arrow_closed = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          }
        }
      }
    }
  }
end

return M
