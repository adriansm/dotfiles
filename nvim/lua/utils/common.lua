local M = {}

function M.set_options(options)
    for key, val in pairs(options) do
        if val == true then
            vim.api.nvim_command('set ' .. key)
        elseif val == false then
            vim.api.nvim_command('set no' .. key)
        else
            vim.api.nvim_command('set ' .. key .. '=' .. val)
        end
    end
end

function M.prequire(module)
  local status, lib = pcall(require, module)
  if (status) then
    return lib
  else
    return nil
  end
end

return M
