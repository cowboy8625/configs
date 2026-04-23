-- Function to convert the number under the cursor to hex
function ConvertNumberUnderCursorToHex()
  -- Get the word under the cursor
  local word = vim.fn.expand '<cword>'

  -- Check if the word is a number
  local num = tonumber(word)
  if num then
    -- Convert the number to hexadecimal
    local hex_value = string.format('0x%X', num)

    -- Replace the number under the cursor with the hex value
    vim.cmd('normal! ciw' .. hex_value)
  else
    print 'Not a valid number under the cursor'
  end
end

-- Map a keybinding to trigger the conversion (e.g., <leader>xh)
vim.api.nvim_set_keymap('n', '<leader>xh', ':lua ConvertNumberUnderCursorToHex()<CR>', { noremap = true, silent = true })
