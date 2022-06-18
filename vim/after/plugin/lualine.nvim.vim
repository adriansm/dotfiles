if !has('nvim') | finish | endif

lua << EOF
require('lualine').setup {
      options = {
            theme = 'wombat'
      },
      tabline = {
            lualine_a = {
                  {
                        'buffers',
                        show_filename_only = true,   -- Shows shortened relative path when set to false.
                        show_modified_status = true, -- Shows indicator when the buffer is modified.

                        mode = 0, -- 0: Shows buffer name
                              -- 1: Shows buffer index (bufnr)
                              -- 2: Shows buffer name + buffer index (bufnr)

                        max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                                                            -- it can also be a function that returns
                                                            -- the value of `max_length` dynamically.
                        filetype_names = {
                              TelescopePrompt = 'Telescope',
                              dashboard = 'Dashboard',
                              packer = 'Packer',
                              fzf = 'FZF',
                              alpha = 'Alpha'
                        }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
                  }
            },
            lualine_z = {'tabs'}
      }
}
EOF
