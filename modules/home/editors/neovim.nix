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
    extraLuaConfig = ''
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.termguicolors = true'';
    plugins = with pkgs.vimPlugins; [

    ];
  };
}
