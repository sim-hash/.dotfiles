# Neovim Configuration

Personal Neovim setup using native LSP (v0.11+) with fuzzy finding, debugging, and Git integration.

## What's Inside

- **LSP**: Lua, Python, Go, Rust, C/C++, Java via Mason
- **Fuzzy Finding**: Telescope for files and search
- **Navigation**: Harpoon for quick file switching
- **Git**: Fugitive integration
- **Debugging**: DAP support for Go and Rust
- **Theme**: Nordic colorscheme

## Quick Start

```bash
# Install plugins
nvim +PackerSync

# Install language servers
nvim +Mason
```

## Requirements

- Neovim 0.11+
- ripgrep
- Git

## Work in Progress

This config is being actively developed:

- [ ] Migration from Packer to **Lazy.nvim** (see commented code in `lua/sim-hash/lazy_init.lua`)
- [ ] Cleanup commented configurations and old theme experiments
- [ ] Integration with broader dotfiles repository (Ansible scripts, i3wm config, etc.)
- [ ] Treesitter context support
- [ ] Additional LSP server configurations

Check the commented sections in the code for experimental features and planned changes.
