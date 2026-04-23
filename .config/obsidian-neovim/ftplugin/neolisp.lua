vim.o.makeprg = [[ neolisp --no-color run % 2>&1 ]]

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.bo.softtabstop = 0
vim.bo.commentstring = '; %s'

vim.opt.errorformat = table.concat({
  [[%E[%t%n] Error: %m]], -- Match the main error line like: [E003] Error: ...
  [[%C%\\s%#╭─[%\\s]%#%f:%l:%c%\\s%#%\\] ]], -- Match the file/line/col inside the box: ╭─[ file:line:col ]
  [[%-G%\\s%#│%#]], -- Skip all box body lines:    │ ...
  [[%-G─────╯]], -- Skip the box footer line
}, ',')

local function openQuickfixListInTelescope()
  if #vim.fn.getqflist() == 0 then
    vim.notify('✅ No errors', vim.log.levels.INFO)
    return
  end

  require('telescope.builtin').quickfix {
    layout_strategy = 'vertical',
    layout_config = {
      prompt_position = 'top',
      horizontal = { width = 0.9, height = 0.9 },
      vertical = { height = 0.9, width = 0.9 },
      preview_height = 0.7,
    },
  }
end

local function neolispRun()
  vim.cmd [[ cexpr [] ]]
  vim.cmd [[ silent make ]]
  openQuickfixListInTelescope()
end

vim.api.nvim_create_user_command('NeolispRun', neolispRun, { desc = 'Neolisp Run' })

vim.keymap.set('n', ';;', ':NeolispRun<CR>')
