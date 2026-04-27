local function convert_number_under_cursor_to_hex()
  local word = vim.fn.expand("<cword>")
  local num = tonumber(word)
  if num then
    local hex_value = string.format("0x%X", num)
    vim.cmd("normal! ciw" .. hex_value)
  else
    error("Not a valid number under the cursor", vim.log.levels.ERROR)
  end
end

vim.keymap.set("n", "<leader>xh", convert_number_under_cursor_to_hex, { noremap = true, silent = true })
