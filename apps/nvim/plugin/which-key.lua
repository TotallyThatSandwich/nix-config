local wk = require("which-key")

wk.setup({
  	plugins = {
    	spelling = false,
    	presets = false, -- no default preset hints
  	},
  	win = {
    	border = "rounded",
    	position = "bottom", -- only bottom is supported, so we'll fake bottom-right
    	margin = { 1, 1, 1, 1 }, -- move it inward
    	padding = { 1, 2, 1, 2 },
  	},
  	layout = {
    	align = "right", -- this makes it look bottom-right like LazyVim
  	},
  	triggers = {}, -- disable auto popup
})

-- Manual trigger with <leader>?
vim.keymap.set("n", "<leader>?", function()
  	wk.show()
end, { desc = "Show which-key menu" })

-- Example: define some groups
wk.register({
  	f = { name = "+file", f = { "<cmd>Telescope find_files<cr>", "Find File" } },
  	g = {
    	name = "+git",
    	g = { "<cmd>Neogit<CR>", "Open Neogit" },
    	s = { "<cmd>Neogit kind=split<CR>", "Status (split)" },
    	c = { "<cmd>Neogit commit<CR>", "Commit" },
    	p = { "<cmd>Neogit push<CR>", "Push" },
    	l = { "<cmd>Neogit log<CR>", "Log" },
  	},
}, { prefix = "<leader>" })
