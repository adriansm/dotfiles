local M = {}

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
  if vim.g.loaded_lspsaga then
    keymap.map('normal_mode', {
      ['K'] = '<Cmd>Lspsaga hover_doc<CR>',
      ['gh'] = '<Cmd>Lspsaga hover_doc<CR>',
      ['gr'] = '<Cmd>Lspsaga lsp_finder<CR>',
      ['gp'] = '<Cmd>Lspsaga preview_definition<CR>',
      ['gs'] = '<Cmd>Lspsaga signature_help<CR>',

      ['<leader>ca'] = '<cmd>Lspsaga code_action<CR>',
      ['<leader>rn'] = '<cmd>Lspsaga rename<CR>',
    })
    keymap.map('visual_mode', {
      ['<leader>ca'] = '<cmd>Lspsaga range_code_action<CR>',
    })
  else
    keymap.map('normal_mode', {
      ['K'] = '<Cmd>lua vim.lsp.buf.hover()<CR>',
      ['gh'] = '<Cmd>lua vim.lsp.buf.hover()<CR>',
      ['gr'] = '<cmd>lua vim.lsp.buf.references()<CR>',
      ['gs'] = '<cmd>lua vim.lsp.buf.signature_help()<CR>',

      ['<leader>ca'] = '<cmd>lua vim.lsp.buf.code_action()<CR>',
      ['<leader>rn'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
    })
  end

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
  client.resolved_capabilities.document_formatting = false

  if client.resolved_capabilities.document_formatting then
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

function M.setup()
  nvim_lsp = prequire('lspconfig')
  if not nvim_lsp then
    return
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if vim.g.loaded_cmp then
    -- Set up completion using nvim_cmp with LSP source if available
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  end

  local lsp_installer = prequire('nvim-lsp-installer')
  if lsp_installer then
    local on_server_ready = function(server)
        local opts = {
          on_attach = on_attach,
          capabilities = capabilities
        }

        -- (optional) Customize the options passed to the server
        -- if server.name == "tsserver" then
        --     opts.root_dir = function() ... end
        -- end

        -- This setup() function is exactly the same as lspconfig's setup function.
        -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        server:setup(opts)
    end

    -- Register a handler that will be called for all installed servers.
    -- Alternatively, you may also register handlers on specific server instances instead (see example below).
    lsp_installer.on_server_ready(on_server_ready)
  end
end

return M
