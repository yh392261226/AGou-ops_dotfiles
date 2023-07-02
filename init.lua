require('config.options')
require('config.lazy')
require('config.highlights')
require('config.autocmds')

vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        require('config.keymaps')
        require('utils')
    end,
})