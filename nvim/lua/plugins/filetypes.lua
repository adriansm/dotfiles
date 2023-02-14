return {
  {
    "nathom/filetype.nvim",
    init = function()
      vim.g.did_load_filetypes = 1
    end,
    opts = {
      overrides = {
        extensions = {
          aidl = "java",
          cmm = "practice",
          dts = "dts",
          dtsi = "dts",
          hal = "java",
          proto = "proto",
          asciipb = "protobuf",
        },
        complex = {
          [".*/.ssh/config.d/.*"] = "sshconfig",
        }
      }
    }
  }
}
