local is_neotree_focused = function()
  -- Get our current buffer number
  local bufnr = vim.api.nvim_get_current_buf and vim.api.nvim_get_current_buf() or vim.fn.bufnr()
  -- Get all the available sources in neo-tree
  for _, source in ipairs(require("neo-tree").config.sources) do
    -- Get each sources state
    local state = require("neo-tree.sources.manager").get_state(source)
    -- Check if the source has a state, if the state has a buffer and if the buffer is our current buffer
    if state and state.bufnr and state.bufnr == bufnr then
      return true
    end
  end
  return false
end
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = is_neotree_focused(), dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = is_neotree_focused(), dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = is_neotree_focused() })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = is_neotree_focused() })
        end,
        desc = "Buffer Explorer",
      },
    },
    opts = {
      window = {
        mappings = {
          ["s"] = "split_with_window_picker",
          ["v"] = "vsplit_with_window_picker",
          ["<cr>"] = "open_with_window_picker",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every time
          --               -- the current file is changed while the tree is open.
          leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
      },
    },
  },
}
