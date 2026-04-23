local function get_redis_data(args)
  if #args.fargs == 0 then
    print 'Please provide a Redis key as an argument.'
    return
  end

  local redis_key = args.fargs[1]
  local command = string.format('redis-cli get %s', redis_key)

  local handle = io.popen(command)

  if handle == nil then
    print 'Error: Failed to execute Redis command.'
    return
  end

  local result = handle:read '*a'
  handle:close()

  vim.cmd 'tabnew'
  local buffer = vim.api.nvim_get_current_buf()

  local buffer_content = vim.split(result, '\n')

  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, buffer_content)

  vim.bo.filetype = 'json'

  -- using plugin for formating like a damn noob
  vim.cmd 'JqxList'
  vim.cmd 'q'
end

---@return nil
local function save_to_redis(args)
  if #args.fargs == 0 then
    print 'Please provide a Redis key as an argument.'
    return
  end

  local redis_key = args.fargs[1]
  local buffer = vim.api.nvim_get_current_buf()
  local buffer_content = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
  local buffer_string = table.concat(buffer_content)

  buffer_string = vim.trim(buffer_string)

  local redis_set_command = string.format("redis-cli set %s '%s'", redis_key, buffer_string)

  local output = vim.fn.system(redis_set_command)

  if vim.v.shell_error ~= 0 then
    print('Error saving to Redis: ' .. output)
  else
    print 'Successfully saved to Redis.'
  end
end

vim.api.nvim_create_user_command('SaveToRedis', save_to_redis, { nargs = 1 })
vim.api.nvim_create_user_command('LoadRedisData', get_redis_data, { nargs = 1 })
