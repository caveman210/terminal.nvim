local M = {}

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
  local bufnr = vim.fn.termopen(vim.o.shell)

  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')

  vim.keymap.set('t', 'jk', '<C-\\><C-n>', {
    buffer = bufnr,
    noremap = true,
    silent = true,
    desc = 'Exit Terminal Mode',
  })

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_buf_delete(0, { force = true })
  end, {
    buffer = bufnr,
    noremap = true,
    silent = true,
    desc = 'Close Terminal Window',
  })

  local win_config = M.get_window_config()

  local win_id = vim.api.nvim_open_win(bufnr, true, win_config)

  vim.api.nvim_win_set_option(win_id, 'number', false)
  vim.api.nvim_win_set_option(win_id, 'relativenumber', false)
  vim.api.nvim_win_set_option(win_id, 'cursorline', false)

  vim.cmd 'startinsert'
end

return M
