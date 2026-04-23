vim.cmd [[ set makeprg=gcc\ %\ -o\ %:r]]
vim.keymap.set('n', ';;', ':make<CR>')
