return {
  "yioneko/nvim-vtsls",
  dependencies = { "neovim/nvim-lspconfig" },
  ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  config = function()
    local lspconfig = require("lspconfig")
    local project_tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
    
    -- Check if local TypeScript SDK exists, fallback to global if not
    local tsdk_path = project_tsdk
    if vim.fn.isdirectory(project_tsdk) == 0 then
      -- Try common global TypeScript locations
      local global_paths = {
        "/usr/local/lib/node_modules/typescript/lib",
        "/opt/homebrew/lib/node_modules/typescript/lib",
        vim.fn.expand("~/.npm-global/lib/node_modules/typescript/lib"),
      }
      
      for _, path in ipairs(global_paths) do
        if vim.fn.isdirectory(path) == 1 then
          tsdk_path = path
          break
        end
      end
    end

    lspconfig.vtsls.setup({
      settings = {
        vtsls = {
          tsdk = tsdk_path,
          autoUseWorkspaceTsdk = false,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
      },
    })
  end,
}
