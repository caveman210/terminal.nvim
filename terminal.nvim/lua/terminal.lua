---@diagnostic disable: undefined-global

local M = {}

-- Helper function to get window layout
M.get_window_config = function()
  local editor_height = vim.api.nvim_get_option_value('lines', {})
  local editor_width = vim.api.nvim_get_option_value('columns', {})
  local win_height = math.floor(editor_height * 0.85)
  local win_width = math.floor(editor_width * 0.85)
  local row = math.floor((editor_height - win_height) / 2)
  local col = math.floor((editor_width - win_width) / 2)

  return {
    relative = 'editor',
    height = win_height,
    width = win_width,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }
end

M.create_term = function()
  -- 1. Create the terminal and run your shell
  local bufnr = vim.fn.termopen(vim.o.shell)

  -- 2. Set buffer-local options
  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')

  -- 3. KEYMAP: Exit terminal mode (jk -> Normal Mode)
  vim.keymap.set('t', 'jk', '<C-\\><C-n>', {
    buffer = bufnr,
    noremap = true,
    silent = true,
    desc = 'Exit Terminal Mode',
  })

  -- 4. KEYMAP: Close the window (q -> Close)
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_buf_delete(0, { force = true })
  end, {
    buffer = bufnr,
    noremap = true,
    silent = true,
    desc = 'Close Terminal Window',
  })

  -- 5. Get the window layout
  local win_config = M.get_window_config()

  -- 6. Open the floating window
  local win_id = vim.api.nvim_open_win(bufnr, true, win_config)

  -- 7. Set window-local options
  vim.api.nvim_win_set_option(win_id, 'number', false)
  vim.api.nvim_win_set_option(win_id, 'relativenumber', false)
  vim.api.nvim_win_set_option(win_id, 'cursorline', false)

  -- 8. Enter Terminal mode
  vim.cmd 'startinsert'
end

return M
