local utils = require('custom.config.utils')
-- Go to file tree
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Go to file tree' })
vim.keymap.set('n', '<leader>kd', vim.diagnostic.open_float, { desc = 'Open diagnostic hover window' })

-- Go to daily note
vim.keymap.set('n', '<leader>dn', utils.open_daily_note, { desc = 'Go to daily note' })
