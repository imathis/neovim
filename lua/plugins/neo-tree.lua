vim.api.nvim_create_user_command("OpenInFinder", function()
  local path = vim.fn.expand("%:p")
  if vim.fn.has("mac") == 1 then
    vim.fn.system("open -R " .. path)
  elseif vim.fn.has("win32") == 1 then
    -- Windows equivalent
    vim.fn.system("explorer /select, " .. path)
  else
    -- Linux, assuming you have something like xdg-open or nautilus installed
    vim.fn.system("xdg-open " .. vim.fn.fnamemodify(path, ":h"))
  end
end, {})

local is_neotree_focused = function()
  -- Get our current buffer number
  local bufnr = vim.api.nvim_get_current_buf and vim.api.nvim_get_current_buf() or vim.fn.bufnr()

  -- Safely require neo-tree and check if it’s loaded
  local status_ok, neo_tree = pcall(require, "neo-tree")
  if not status_ok then
    return false -- Return false if neo-tree isn’t loaded
  end

  -- Try to get the neo-tree config safely
  local config = neo_tree.config or {}
  local sources = config.sources or { "filesystem", "buffers", "git_status" } -- Default sources if config is nil

  -- Safely iterate over sources and check their states with pcall
  for _, source in ipairs(sources) do
    local manager = require("neo-tree.sources.manager")
    local ok, state = pcall(manager.get_state, source)
    if ok and state and type(state) == "table" and state.bufnr and state.bufnr == bufnr then
      return true
    end
  end
  return false
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- Optional, for icons
      "MunifTanjim/nui.nvim",
    },
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
          ["R"] = function(state)
            -- Safely get the node
            local node = state and state.tree and state.tree:get_node()

            if not node then
              vim.notify("No file selected", vim.log.levels.WARN)
              return
            end

            -- Check if the node has a path
            local file_path = node.path or node.full_path or node:get_id()

            if not file_path then
              vim.notify("Unable to determine file path", vim.log.levels.ERROR)
              return
            end

            -- Ensure the path exists
            if vim.fn.filereadable(file_path) == 1 or vim.fn.isdirectory(file_path) == 1 then
              -- Use macOS 'open' command to reveal in Finder
              vim.fn.system(string.format("open -R '%s'", file_path))
              vim.notify("Revealed in Finder: " .. file_path, vim.log.levels.INFO)
            else
              vim.notify("File or directory does not exist: " .. file_path, vim.log.levels.ERROR)
            end
          end,
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
    end,
  },
}
