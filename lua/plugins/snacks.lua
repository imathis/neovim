return {
  "folke/snacks.nvim",
  dependencies = { "s1n7ax/nvim-window-picker" },
  opts = {
    zen = {
      win = {
        width = 200, -- Set the Zen window width to 200 columns
      },
    },
    explorer = {
      replace_netrw = true,
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    
    -- Add custom keymaps when snacks explorer opens
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "snacks_picker_list", "snacks_explorer" },
      callback = function(event)
        local buf = event.buf
        local ft = vim.bo[buf].filetype
        
        print("Setting up keymaps for buffer:", buf, "filetype:", ft)
        
        -- Reveal in Finder
        vim.keymap.set("n", "R", function()
            print("R key pressed in snacks explorer")
            local pickers = require("snacks.picker").get({source = "explorer"})
            local picker = pickers and pickers[1]
            
            if picker then
              local item = picker:current()
              if item and item.file then
                local path = item.file
                vim.schedule(function()
                  if vim.fn.has("mac") == 1 then
                    vim.fn.system(string.format("open -R '%s'", path))
                    print("Revealed in Finder: " .. vim.fn.fnamemodify(path, ":t"))
                  end
                end)
              else
                print("No file selected")
              end
            else
              print("No explorer picker found")
            end
        end, { buffer = buf, desc = "Reveal in Finder" })
        
        -- Window picker for Ctrl+CR  
        vim.keymap.set("n", "<C-CR>", function()
          print("Ctrl+CR pressed in snacks explorer")
          local pickers = require("snacks.picker").get({source = "explorer"})
          local picker = pickers and pickers[1]
          
          if picker then
            local item = picker:current()
            if item and item.file then
              local file_path = item.file
              print("Opening file with window picker:", file_path)
              
              vim.schedule(function()
                local window_picker = require("window-picker")
                local win_id = window_picker.pick_window({
                  hint = "floating-big-letter",
                  filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    bo = {
                      filetype = { "snacks_picker_list", "snacks_explorer", "notify", "neo-tree", "neo-tree-popup", "trouble", "qf", "help", "man", "lspinfo", "spectre_panel", "startuptime", "checkhealth" },
                      buftype = { "terminal", "quickfix", "nofile", "help", "acwrite", "prompt" },
                    },
                  },
                })
                
                if win_id and win_id ~= -1 then
                  vim.api.nvim_set_current_win(win_id)
                  vim.cmd("edit " .. vim.fn.fnameescape(file_path))
                else
                  -- No valid window picked, just open in current window
                  vim.cmd("edit " .. vim.fn.fnameescape(file_path))
                end
              end)
            else
              print("No file selected")
            end
          else
            print("No explorer picker found")
          end
        end, { buffer = buf, desc = "Open with window picker" })
      end,
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        -- Check if explorer is already open
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if ft == "snacks_picker_list" or ft == "snacks_explorer" then
            -- Explorer is open, focus it
            vim.api.nvim_set_current_win(win)
            return
          end
        end
        -- Explorer not open, open it
        require("snacks").explorer()
      end,
      desc = "Toggle Snacks Explorer",
    },
  },
}
