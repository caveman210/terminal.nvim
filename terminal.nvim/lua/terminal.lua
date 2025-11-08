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
    border = 'none',
  }
end

M.create_term = function()
  local win_config = M.get_window_config()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
  local win_id = vim.api.nvim_open_win(bufnr, true, win_config)
  vim.api.nvim_win_set_option(win_id, 'number', false)
  vim.api.nvim_win_set_option(win_id, 'relativenumber', false)
  vim.api.nvim_win_set_option(win_id, 'cursorline', false)
  vim.cmd 'terminal'
  local term_bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.set('t', 'jk', '<C-\\><C-n>', {
    buffer = term_bufnr,
    noremap = true,
    silent = true,
    desc = 'Exit Terminal Mode',
  })
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_buf_delete(0, { force = true })
  end, {
    buffer = term_bufnr,
    noremap = true,
    silent = true,
    desc = 'Close Terminal Window',
  })
  vim.cmd 'startinsert'
end

return M
