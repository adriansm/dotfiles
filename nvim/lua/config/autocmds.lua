local opt = vim.opt

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Custom file types
local filetypes = {
  bash = {"build.config*"},
  bzl = {"*.bazel"},
  dts = {"*.dts", "*.dtsi"},
  java = {"*.aidl", "*.hal"},
  practice = {"*.cmm"},
  proto = {"*.proto"},
  protobuf = {"*.asciipb"},
  sshconfig = {".*/.ssh/config.d/.*"},
}

for ft, p in pairs(filetypes) do
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = "filetypedetect",
    pattern = p,
    command = "setfiletype " .. ft,
  })
end

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "cpp",
    "c",
  },
  callback = function()
    vim.g.root_spec = { { "BUILD.bazel", ".git" }, "lsp", "cwd" }
  end,
})

-- Terminal specific options
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    opt.number = false
    opt.relativenumber = false
  end,
})
