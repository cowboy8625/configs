-- Prevent leaving the file if 'it.only(' is found in a Cypress test file
function CheckCypressOnly()
  for i = 1, vim.fn.line '$' do
    local line_text = vim.fn.getline(i)
    if vim.fn.match(line_text, [[\v(\s*)it\.only\(]]) > -1 then
      local choice = vim.fn.confirm("Error: 'it.only(' found. Do you really want to exit?", '&Yes\n&No', 2)
      if choice == 2 then
        vim.api.nvim_err_writeln 'Leaving the file canceled.'
        return 1
      end
    end
  end

  return 0
end

-- Add an autocmd to trigger the function before attempting to close the buffer
vim.api.nvim_exec(
  [[
    augroup cypress_only_check
        autocmd!
        autocmd BufUnload *.js,*.ts call v:lua.CheckCypressOnly()
    augroup END
]],
  false
)
