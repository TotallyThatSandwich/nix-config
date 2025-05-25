vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.clipboard = 'unnamedplus'

vim.o.number = true
vim.o.relativenumber = true

vim.o.signcolumn = 'yes'

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.updatetime = 300

vim.o.termguicolors = true

vim.o.mouse = 'a'


vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {
    noremap = true
})

vim.keymap.set('n', '', '<C-W>h', {desc = 'window Left'})
vim.keymap.set('n', '', '<C-W>l', {desc = 'window Right'})
