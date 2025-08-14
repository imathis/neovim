return {
  "echasnovski/mini.files",
  dependencies = { "s1n7ax/nvim-window-picker" },
  opts = {
    -- Minimal config that worked for split mode
    windows = {
      preview = true,
    },
  },
  config = function(_, opts)
    require("mini.files").setup(opts)
    
    -- Custom mappings
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        
        -- Map Shift+R to reveal in Finder
        vim.keymap.set("n", "R", function()
          local mini_files = require("mini.files")
          local entry = mini_files.get_fs_entry()
          if entry then
            local path = entry.path
            vim.schedule(function()
              if vim.fn.has("mac") == 1 then
                vim.fn.system(string.format("open -R '%s'", path))
                print("Revealed in Finder: " .. vim.fn.fnamemodify(path, ":t"))
              elseif vim.fn.has("win32") == 1 then
                vim.fn.system(string.format('explorer /select,"%s"', path))
              else
                vim.fn.system(string.format("xdg-open '%s'", vim.fn.fnamemodify(path, ":h")))
              end
            end)
          end
        end, { buffer = buf_id, desc = "Reveal in Finder" })

        -- Map 's' for horizontal split with window picker
        vim.keymap.set("n", "s", function()
          local mini_files = require("mini.files")
          local entry = mini_files.get_fs_entry()
          if entry and entry.fs_type == "file" then
            local file_path = entry.path
            mini_files.close()
            vim.schedule(function()
              local picker = require("window-picker")
              local win_id = picker.pick_window({
                hint = "floating-big-letter",
                filter_rules = {
                  include_current_win = true,
                  autoselect_one = false,
                },
              })
              if win_id and win_id ~= -1 then
                vim.api.nvim_set_current_win(win_id)
              end
              vim.cmd("split " .. file_path)
            end)
          end
        end, { buffer = buf_id, desc = "Split with window picker" })

        -- Map 'v' for vertical split with window picker
        vim.keymap.set("n", "v", function()
          local mini_files = require("mini.files")
          local entry = mini_files.get_fs_entry()
          if entry and entry.fs_type == "file" then
            local file_path = entry.path
            mini_files.close()
            vim.schedule(function()
              local picker = require("window-picker")
              local win_id = picker.pick_window({
                hint = "floating-big-letter",
                filter_rules = {
                  include_current_win = true,
                  autoselect_one = false,
                },
              })
              if win_id and win_id ~= -1 then
                vim.api.nvim_set_current_win(win_id)
              end
              vim.cmd("vsplit " .. file_path)
            end)
          end
        end, { buffer = buf_id, desc = "Vsplit with window picker" })

        -- Override default <CR> to use window picker
        vim.keymap.set("n", "<CR>", function()
          local mini_files = require("mini.files")
          local entry = mini_files.get_fs_entry()
          if entry then
            if entry.fs_type == "file" then
              local file_path = entry.path
              mini_files.close()
              vim.schedule(function()
                local picker = require("window-picker")
                local win_id = picker.pick_window({
                  hint = "floating-big-letter",
                  filter_rules = {
                    include_current_win = true,
                    autoselect_one = false,
                    bo = {
                      filetype = { "neo-tree", "neo-tree-popup", "notify" },
                      buftype = { "terminal", "quickfix" },
                    },
                  },
                })
                if win_id and win_id ~= -1 then
                  vim.api.nvim_set_current_win(win_id)
                end
                vim.cmd("edit " .. file_path)
              end)
            else
              -- For directories, use default behavior
              mini_files.go_in()
            end
          end
        end, { buffer = buf_id, desc = "Open with window picker" })
      end,
    })
  end,
  keys = {
    {
      "<leader>fm",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files floating",
    },
  },
}