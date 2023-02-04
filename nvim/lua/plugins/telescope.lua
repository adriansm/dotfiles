
local function project_files(args)
  local opts = args or {} -- define here if you want to define something
  local ok = pcall(require('telescope.builtin').git_files, opts)
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

local function telescope_setup()
  local actions = require('telescope.actions')
  local action_layout = require('telescope.actions.layout')

  require('telescope').setup({
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
  })

  -- To get fzf loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  require("telescope").load_extension('fzf')
  -- telescope.load_extension('ui-select')
end


--
-- [[ Telescope related plug-ins and config ]]
--

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = telescope_setup,
    cmd = "Telescope",

    keys = {
      -- Find files using Telescope command-line sugar.
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },

      -- File search
      { ";;", "<cmd>Telescope buffers<cr>", desc = "Browse open buffers" },
      { ";b", "<cmd>Telescope buffers<cr>", desc = "Browse open buffers" },
      { ";f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { ";p", function() project_files({use_git_root=true}) end, desc = "Find files within git project" },
      { ";o", function() project_files({use_git_root=false}) end, desc = "Find file in current working dir" },

      -- Grep Search
      { ";g", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { ";w", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },

      { ";c", "<cmd>Telescope commands<cr>", desc = "Show list of commands" },
      { ";t", "<cmd>Telescope help_tags<cr>", desc = "Show list of help tags" },

      -- LSP key bindings
      { ";r", "<cmd>Telescope lsp_references<cr>", desc = "List of LSP references" },
      { ";s", "<cmd>Telescope lsp_document_symbols<cr>", desc = "List of document symbols" },
      { ";i", "<cmd>Telescope lsp_implementations<cr>", desc = "List of implementations" },
      { ";d", "<cmd>Telescope lsp_definitions<cr>", desc = "List of definitions" },
      { ";x", "<cmd>Telescope diagnostics<cr>", desc = "List of Diagnostics" },
    }
  },
}
