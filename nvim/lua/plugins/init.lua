local function lazy_bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local function lazy_setup()
  lazy_bootstrap()

  require('lazy').setup("plugins.lazy")
end

local function packer_setup()
  -- Set up packer plugins
  require('plugins.packer').setup()
end

return {
  setup = lazy_setup
}
