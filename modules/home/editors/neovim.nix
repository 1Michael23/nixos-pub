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
    extraLuaConfig = "vim.o.number = true\n	      \n	  vim.o.relativenumber = true\n	      \n	  vim.o.termguicolors = true\n    ";

    plugins = with pkgs.vimPlugins; [

    ];
  };
}
