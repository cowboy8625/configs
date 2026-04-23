return {
  'voldikss/vim-floaterm',
  config = function()
    vim.g.floaterm_gitcommit = 'floaterm'
    vim.g.floaterm_title = ''
    vim.g.floaterm_autoinsert = 1
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    vim.g.floaterm_wintitle = 0
    vim.g.floaterm_autoclose = 1
    vim.g.floaterm_borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }

    local function keymap(key)
      vim.keymap.set('n', key, ':FloatermToggle<CR>', { desc = 'Toggle [F]loaterm', silent = true })
      vim.keymap.set('i', key, '<C-o>:FloatermToggle<CR>', { desc = 'Toggle [F]loaterm', silent = true })
      vim.keymap.set('t', key, '<c-\\><c-n>:FloatermToggle<CR>', { desc = 'Toggle [F]loaterm', silent = true })
    end

    keymap '<c-/>'
    keymap '<c-_>'

    -- Define a highlight group for Floaterm border
    local color = vim.api.nvim_get_hl_by_name('Normal', true)
    vim.api.nvim_set_hl(0, 'FloatermBorder', { bg = color.background, fg = color.foreground })
  end,
}
