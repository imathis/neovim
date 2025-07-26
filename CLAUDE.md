# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a LazyVim-based Neovim configuration that uses the Lazy.nvim plugin manager. The configuration follows LazyVim's modular architecture with custom plugins and overrides.

## Key Architecture

### Configuration Structure
- `init.lua` - Entry point that bootstraps Lazy.nvim and loads config
- `lua/config/` - Core configuration files
  - `lazy.lua` - Lazy.nvim setup and plugin loading
  - `options.lua` - Neovim options (minimal, inherits LazyVim defaults)
  - `keymaps.lua` - Custom key mappings
  - `autocmds.lua` - Auto-commands (currently just trailing whitespace removal)
- `lua/plugins/` - Individual plugin configurations that extend/override LazyVim defaults

### Plugin Management
- Uses Lazy.nvim for plugin management
- Follows LazyVim's plugin specification format
- Each plugin file in `lua/plugins/` returns a table/spec
- Plugin specs can extend LazyVim defaults or add new plugins
- `lazy-lock.json` locks plugin versions for reproducible installs

### LazyVim Integration
- Inherits from LazyVim base configuration
- Uses LazyVim extras system (see `lazyvim.json`)
- Custom plugins extend rather than replace LazyVim functionality
- Many defaults inherited from LazyVim (see commented references in config files)

## Development Workflow

### Plugin Development
- Create new plugin files in `lua/plugins/` following the naming pattern
- Each plugin file should return a valid Lazy.nvim spec
- Use LazyVim's plugin override patterns to extend existing functionality
- The `example.lua` file shows common patterns but is disabled (`if true then return {} end`)

### Configuration Changes
- Edit files in `lua/config/` for core Neovim settings
- Edit files in `lua/plugins/` for plugin-specific configurations
- Changes are automatically loaded due to LazyVim's lazy loading setup

### Code Style
- Uses StyLua for Lua formatting (config in `stylua.toml`)
- 2-space indentation, 120 column width
- Follows LazyVim's coding conventions

## Key Features & Customizations

### Terminal Integration
- Custom terminal toggles using Snacks.nvim
- `<C-\>` - Toggle right-side terminal
- `<C-f>` - Toggle floating terminal
- Both terminals run zsh by default

### Navigation & Editing
- Custom tab navigation keymaps (`<leader>l/h` for next/previous tab)
- Enhanced movement (`H`/`L` for line start/end)
- Yanky integration for improved copy/paste workflow
- Visual mode text replacement (`R` in visual mode)

### File Management
- Neo-tree for file exploration
- Telescope for fuzzy finding
- Custom config file picker (`<leader>cc`)

### Notable Plugin Configurations
- **Snacks.nvim**: Terminal management and zen mode
- **Aider.nvim**: AI-powered coding assistant integration
- **Avante.nvim**: Currently disabled (commented out)
- **Blink.cmp**: Completion engine (replaced nvim-cmp)
- **Neo-tree**: File explorer with custom settings

## Language Support

Based on `lazyvim.json`, includes support for:
- TypeScript/JavaScript (with VTSLS LSP)
- Astro
- JSON
- Markdown
- Tailwind CSS
- ESLint integration
- Prettier formatting

## Important Notes

- Configuration inherits heavily from LazyVim defaults
- Many settings are minimal overrides rather than full configurations
- Plugin management follows LazyVim's lazy loading patterns
- Terminal integration is customized for zsh workflow
- Relative line numbers are disabled (`relativenumber = false`)
- Auto-removes trailing whitespace on save