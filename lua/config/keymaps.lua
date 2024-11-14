-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- tabs
map("n", "<leader><tab>L", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>H", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>h", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Movement
map("n", "H", "^", { desc = "Move: Line Start" })
map("n", "L", "$", { desc = "Move: Line End" })

-- Yanjy mappings
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Yanky Put After" })
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Yanky Put Before" })
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Yanky GPut After" })
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Yanky GPut Before" })

map("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Yanky Previous" })
map("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Yanky Next" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
map("n", "<leader>qq", "<cmd>q<CR>", { desc = "Close Buffer" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Close All Buffers" })

-- Visual mode keymap for quick substitution of selected text
map("v", "R", function()
  -- Store the current register contents to restore later
  local old_reg = vim.fn.getreg('"')
  local old_regtype = vim.fn.getregtype('"')

  -- Yank the selected text into the unnamed register
  vim.cmd("normal! y")

  -- Get the selected text from the unnamed register
  local selected_text = vim.fn.getreg('"')

  -- Restore the old register contents
  vim.fn.setreg('"', old_reg, old_regtype)

  -- Escape special characters in the selected text
  local escaped_text = selected_text:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "\\%1")

  -- Create and set up the substitution command
  local cmd = ":%s/" .. escaped_text .. "/"

  -- Clear the command line and input the substitution command
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", false)
  vim.fn.feedkeys(cmd)
end, {
  desc = "Replace highlighted text",
  silent = true,
})
