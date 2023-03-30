return {
  {
    "nathom/filetype.nvim",
    init = function()
      vim.g.did_load_filetypes = 1
    end,
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        overrides = {
          extensions = {
            aidl = "java",
            cmm = "practice",
            dts = "dts",
            dtsi = "dts",
            hal = "java",
            proto = "proto",
            asciipb = "protobuf",
            bazel = "bzl",
          },
          complex = {
            [".*/.ssh/config.d/.*"] = "sshconfig",
          }
        }
      })
    end
  },
  {
    "bazelbuild/vim-bazel",
    cmd = "Bazel",
    dependencies = {
      "google/vim-maktaba"
    },
  },
}
