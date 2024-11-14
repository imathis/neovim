-- Function to toggle between dark and light mode for TokyoNight
local function toggle_theme()
  -- Get current background option
  local current_background = vim.o.background

  -- Toggle the background
  if current_background == "dark" then
    -- Switch to light mode
    vim.o.background = "light"
    vim.g.tokyonight_transparent = 0
    -- vim.g.tokyonight_transparent_sidebar = false
    -- vim.g.tokyonight_transparent_floats = false
    vim.cmd("colorscheme tokyonight-day")
    -- Optional: notify user of change
    vim.notify("Switched to light mode", vim.log.levels.INFO)
  else
    -- Switch to dark mode
    vim.o.background = "dark"
    vim.g.tokyonight_transparent = 1
    -- vim.g.tokyonight_transparent_sidebar = true
    -- vim.g.tokyonight_transparent_floats = true
    vim.cmd("colorscheme tokyonight-moon")
    -- Optional: notify user of change
    vim.notify("Switched to dark mode", vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "<leader>tt", toggle_theme, { noremap = true, silent = true, desc = "Toggle theme" })

return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
      light_style = "day",
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
    },
  },
}
