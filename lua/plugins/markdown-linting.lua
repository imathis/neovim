return {
  -- Disable linting for markdown files
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Remove markdownlint from markdown linters
      if opts.linters_by_ft and opts.linters_by_ft.markdown then
        opts.linters_by_ft.markdown = {}
      end
      return opts
    end,
  },
  -- Also disable diagnostics for markdown files
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        -- Disable virtual text for markdown files
        virtual_text = {
          filter = function(diagnostic, bufnr)
            local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
            if filetype == "markdown" then
              return false
            end
            return true
          end,
        },
      },
    },
  },
}