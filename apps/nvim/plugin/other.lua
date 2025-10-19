-- plugins
require("ibl").setup()

-- neogit
local neogit = require("neogit")

neogit.setup({
  kind = "split",         -- open Neogit in a split (can be "tab" or "vsplit")
  disable_commit_confirmation = true,
  integrations = {
    diffview = false,     -- enable if you also install diffview.nvim
  },
})

-- Colorscheme
vim.cmd("colorscheme gruvbox")
