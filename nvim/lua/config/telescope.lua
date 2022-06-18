local M = {}

function M.project_files(args)
  local opts = args or {} -- define here if you want to define something
  local ok = pcall(require('telescope.builtin').git_files, opts)
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

function M.setup()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local action_layout = require('telescope.actions.layout')

  telescope.setup {
    extensions = {
      ["fzf"] = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          -- even more opts
        }
        -- pseudo code / specification for writing custom displays, like the one
        -- for "codeactions"
        -- specific_opts = {
        --   [kind] = {
        --     make_indexed = function(items) -> indexed_items, width,
        --     make_displayer = function(widths) -> displayer
        --     make_display = function(displayer) -> function(e)
        --     make_ordinal = function(e) -> string
        --   },
        --   -- for example to disable the custom builtin "codeactions" display
        --      do the following
        --   codeactions = false,
        -- }
      },
    },
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim" -- add this value
      },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<M-p>"] = action_layout.toggle_preview,
          ["<M-d>"] = actions.delete_buffer,
        },
        n = {
          ["x"] = actions.toggle_selection,
          ["q"] = actions.close,
          ["<M-p>"] = action_layout.toggle_preview,
          ["<M-d>"] = actions.delete_buffer,
        }
      },
    },
  }

  -- To get fzf loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  telescope.load_extension('fzf')
  -- telescope.load_extension('ui-select')
end

return M
