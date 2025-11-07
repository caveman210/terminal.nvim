return {
  {
    dir = '~/.config/nvim/lua/custom/plugins/terminal.nvim',
    keys = {
      {
        '<C-t>',

        function()
          require('terminal').create_term()
        end,

        desc = 'Open Terminal Window',
      },
    },
  },
}
