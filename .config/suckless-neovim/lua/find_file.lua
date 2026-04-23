--=================================================================================================
--                             Find File Command
--=================================================================================================
local function find_file(opts)
  local term = opts.args:lower()

  -- get all files tracked by ripgrep
  local handle = io.popen("rg --files")
  if not handle then
    return
  end

  local result = handle:read("*a")
  handle:close()

  local files = {}
  for line in string.gmatch(result, "[^\r\n]+") do
    -- basic fuzzy: case-insensitive substring match
    if line:lower():find(term, 1, true) then
      table.insert(files, { filename = line })
    end
  end

  if #files == 0 then
    print("No files found")
  elseif #files == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(files[1].filename))
  else
    vim.fn.setqflist({}, " ", { title = "Files", items = files })
    vim.cmd("copen")
  end
end

vim.api.nvim_create_user_command("FindFile", find_file, {
  nargs = 1,
  complete = "file",
})

-- In quickfix window: press 'p' to preview file under cursor
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    local float_win = nil

    local function close_float()
      if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
      end

      float_win = nil
    end

    local function open_preview_floating(bufnr, winnr, lnum, col)
      lnum = lnum or 1
      col = (col or 1) - 1

      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      local row = math.floor((vim.o.lines - height) / 2) - 1
      local col_pos = math.floor((vim.o.columns - width) / 2)

      float_win = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        row = row,
        col = col_pos,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
      })

      vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
      vim.api.nvim_set_option_value("buflisted", false, { buf = bufnr })
      vim.api.nvim_set_option_value(
        "filetype",
        vim.api.nvim_get_option_value("filetype", { buf = bufnr }),
        { buf = bufnr }
      )
      vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })

      local line_count = vim.api.nvim_buf_line_count(bufnr)
      if lnum > line_count then
        lnum = line_count
      end
      if lnum < 1 then
        lnum = 1
      end
      local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
      local line_len = #line
      if col > line_len then
        col = line_len
      end
      if col < 0 then
        col = 0
      end
      vim.api.nvim_win_set_cursor(float_win, { lnum, col })

      vim.api.nvim_set_current_win(float_win)

      vim.keymap.set("n", "<CR>", function()
        for _, win in ipairs(vim.fn.getwininfo()) do
          if win.quickfix == 1 then
            vim.api.nvim_win_close(win.winid, true)
          end
        end

        close_float()

        vim.api.nvim_command("edit " .. vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufnr)))
        vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
        vim.api.nvim_win_set_cursor(0, { lnum, col })
      end, { buffer = bufnr, noremap = true, silent = true })

      vim.keymap.set("n", "<Esc>", close_float, { buffer = bufnr, noremap = true, silent = true })
      vim.keymap.set("n", "q", function()
        close_float()
        vim.api.nvim_set_current_win(winnr)
      end, { buffer = bufnr, noremap = true, silent = true })
    end

    vim.keymap.set("n", "p", function()
      local qf_list = vim.fn.getqflist()
      local idx = vim.fn.line(".")
      local entry = qf_list[idx]
      if entry and entry.bufnr and entry.bufnr > 0 then
        local bufname = vim.fn.bufname(entry.bufnr)
        if vim.fn.filereadable(bufname) == 1 then
          local bufnr = vim.fn.bufadd(bufname)
          vim.fn.bufload(bufnr)

          local winnr = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local current_bufnr = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_get_option(current_bufnr, "buftype") == "quickfix" then
              winnr = win
              break
            end
          end

          open_preview_floating(bufnr, winnr, entry.lnum, entry.col)
        else
          print("File not readable: " .. bufname)
        end
      else
        print("No quickfix entry under cursor")
      end
    end, { buffer = true, noremap = true, silent = true })
  end,
})

local function floating_input(callback)
  local input_buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.5)
  local height = 1
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(input_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    title = "FindFile",
    style = "minimal",
    border = "rounded",
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = input_buf,
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      vim.api.nvim_buf_delete(input_buf, { force = true })
    end,
  })

  -- Buffer settings
  vim.api.nvim_set_option_value("buftype", "", { buf = input_buf })
  vim.api.nvim_set_option_value("filetype", "PromptInput", { buf = input_buf })
  vim.api.nvim_set_option_value("modifiable", true, { buf = input_buf })
  vim.api.nvim_set_option_value("modifiable", true, { buf = input_buf })

  vim.cmd("startinsert!")

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set("i", "<CR>", function()
    local lines = vim.api.nvim_buf_get_lines(input_buf, 0, 1, false)
    local result = lines[1] or ""
    close()
    if callback then
      callback(result)
    end
  end, { buffer = input_buf, noremap = true })

  vim.keymap.set("n", "q", function()
    close()
    if callback then
      callback(nil)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end
  end, { buffer = input_buf, noremap = true })
end

vim.api.nvim_create_user_command("FindFileFloatingInput", function()
  floating_input(function(file_name)
    if not file_name then
      return
    end
    find_file({ args = file_name })
  end)
end, {
  nargs = 0,
})
