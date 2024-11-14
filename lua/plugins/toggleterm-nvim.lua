-- local map = vim.keymap.set
--
-- function _G.set_terminal_keymaps()
--   local opts = { buffer = 0 }
--   map("t", "<esc>", [[<C-\><C-n>]], opts)
--   map("t", "jk", [[<C-\><C-n>]], opts)
--   map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
--   map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
--   map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
--   map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
--   map("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
-- end
--
-- -- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
--
-- map({ "n", "t" }, "<C-;>", "<cmd>ToggleTerm direction=float border=curved<cr>", { desc = "Toggle Floating Terminal" })
-- map("n", "<leader>;", "<cmd>ToggleTerm size=100 direction=vertical<cr>", { desc = "Toggle Vertical Terminal" })
--
-- return {
--   {
--     "akinsho/toggleterm.nvim",
--     version = "*",
--     opts = {
--       size = 20,
--       open_mapping = [[<c-\>]],
--       shade_terminals = true,
--       shading_factor = -10,
--       direction = "float",
--       float_opts = {
--         border = "curved",
--         -- winblend = 5,
--         highlights = {
--           border = "Normal",
--           background = "Normal",
--         },
--       },
--     },
--   },
-- }