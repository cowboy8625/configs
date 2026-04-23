function ConvertNumberUnderCursorToHex()
  local word = vim.fn.expand("<cword>")
  local num = tonumber(word)
  if num then
    local hex_value = string.format("0x%X", num)
    vim.cmd("normal! ciw" .. hex_value)
  else
    print("Not a valid number under the cursor")
  end
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>xh",
  ":lua ConvertNumberUnderCursorToHex()<CR>",
  { noremap = true, silent = true }
)
