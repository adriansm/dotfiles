local prequire = require('utils.common').prequire

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local protocol = prequire('vim.lsp.protocol')
  if not protocol then
    return
  end

  local keymap = require('utils.keymap')

  -- require'completion'.on_attach(client, bufnr)

  --Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  keymap.map('normal_mode', {
    ['K'] = '<Cmd>lua vim.lsp.buf.hover()<CR>',
    ['gh'] = '<Cmd>lua vim.lsp.buf.hover()<CR>',
    ['gr'] = '<cmd>lua vim.lsp.buf.references()<CR>',
    ['gs'] = '<cmd>lua vim.lsp.buf.signature_help()<CR>',

    -- ['<leader>ca'] = '<cmd>lua vim.lsp.buf.code_action()<CR>',
    ['<leader>rn'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
  })

  keymap.map('normal_mode', {
    ['gD'] = '<Cmd>lua vim.lsp.buf.declaration()<CR>',
    ['gd'] = '<Cmd>lua vim.lsp.buf.definition()<CR>',
    ['gi'] = '<cmd>lua vim.lsp.buf.implementation()<CR>',
    ['gt'] = '<cmd>lua vim.lsp.buf.type_definition()<CR>',

    --buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    ['<leader>wa'] = '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
    ['<leader>wr'] = '<cmd>lua vim.lsp.buf.remove_workleader_folder()<CR>',
    ['<leader>wl'] = '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workleader_folders()))<CR>',

    ['<leader>d'] = '<cmd>lua vim.diagnostic.open_float()<CR>',
    ['[d'] = '<cmd>lua vim.diagnostic.goto_prev()<CR>',
    [']d'] = '<cmd>lua vim.diagnostic.goto_next()<CR>',
    ['<leader>q'] = '<cmd>lua vim.diagnostic.setloclist()<CR>',
    ['<leader>f'] = '<cmd>lua vim.lsp.buf.formatting()<CR>',
  })

  -- formatting
  -- if client.name == 'tsserver' or client.name == 'clangd' then
  -- end
  client.server_capabilities.document_formatting = false

  if client.server_capabilities.document_formatting then
    vim.api.nvim_command([[
      augroup Format
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
      augroup END
    ]])
  end

  --protocol.SymbolKind = { }
  protocol.CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  }
end

local function null_ls_setup()
  local nls = prequire("null-ls")
  if not nls then
    return
  end

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

  nls.setup({
    on_init = function(new_client, _)
      new_client.offset_encoding = "utf-16"
    end,
    sources = sources,
    on_attach = on_attach,
  })
end

local function lsp_setup()
  local lspconfig = prequire('lspconfig')
  if not lspconfig then
    return
  end

  local neoconf = prequire('neoconf')
  if neoconf then
    neoconf.setup()
  end

  local neodev = prequire('neodev')
  if neodev then
    neodev.setup()
  end

  local opts = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }

  if vim.g.loaded_cmp then
    -- Set up completion using nvim_cmp with LSP source if available
    opts.capabilities = require('cmp_nvim_lsp').default_capabilities()
    opts.capabilities.offsetEncoding = { "utf-16" }
  end

  -- null-ls
  null_ls_setup()

  -- Installer
  local lspinstaller = prequire('nvim-lsp-installer')
  if lspinstaller then
    lspinstaller.setup{}
    for _, server in ipairs(lspinstaller.get_installed_servers()) do
      lspconfig[server.name].setup(opts)
    end
  end
end


--
-- [[ LSP related Plug-in List ]]
--

return {
  -- Collection of configurations for the built-in LSP client
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/nvim-lsp-installer",
      "jose-elias-alvarez/null-ls.nvim",
      "folke/neoconf.nvim",
      "folke/neodev.nvim",
    },
    config = lsp_setup,
  },

  -- Light bulb shown when a code action is available
  {
    "kosayoda/nvim-lightbulb",
    dependencies = { "antoinemadec/FixCursorHold.nvim" },
    opts = {
      ignore = { "null-ls" },
      {autocmd = {enabled = true}},
      {float = {enable = true}},
    }
  },

  -- Code Action menu for lsp
  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    keys = {
      { ";a", vim.lsp.buf.code_action, desc = "LSP code action" },
      { "<leader>ca", "<cmd>CodeActionMenu<cr>", desc = "Code action menu" },
    },
  },

  -- nvim-lsp progress. Eye candy for the impatient
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    config = true,
  },
}
