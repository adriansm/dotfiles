if !has('nvim') | finish | endif

lua << EOF
require('lualine').setup {
      extensions = {
            'nerdtree'
      },
      options = {
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            theme = 'vscode'
      },
      tabline = {
            lualine_c = { require('tabline').tabline_buffers },
            lualine_x = { require('tabline').tabline_tabs }
      }
}
EOF
