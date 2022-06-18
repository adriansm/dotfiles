local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

-- some configs may need to happen before setup

nvim_tree.setup()
