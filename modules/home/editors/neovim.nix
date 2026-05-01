{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      nil
      nixd
      nixfmt-rfc-style
      rust-analyzer
      pyright
      ruff
    ];

    initLua = ''
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.termguicolors = true
      vim.o.signcolumn = "yes"
      vim.o.cursorline = true
      vim.o.scrolloff = 8
      vim.o.sidescrolloff = 8
      vim.o.wrap = false

      vim.o.expandtab = true
      vim.o.shiftwidth = 4
      vim.o.tabstop = 4
      vim.o.softtabstop = 4
      vim.o.smartindent = true

      vim.o.ignorecase = true
      vim.o.smartcase = true
      vim.o.incsearch = true
      vim.o.hlsearch = false

      vim.o.undofile = true
      vim.o.updatetime = 250
      vim.o.timeoutlen = 300
      vim.o.clipboard = "unnamedplus"
      vim.o.splitright = true
      vim.o.splitbelow = true

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.nix",
        callback = function() vim.lsp.buf.format() end,
      })

    '';
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      plenary-nvim

      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.lua
        p.rust
        p.python
        p.bash
        p.markdown
        p.yaml
        p.toml
        p.json
      ]))

      nvim-tree-lua
      nvim-web-devicons

      lualine-nvim

      gitsigns-nvim
      vim-fugitive

    ];
  };
}
