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
    initLua = ''
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.termguicolors = true'';
    plugins = with pkgs.vimPlugins; [
      #TODO neovim plugins
    ];
  };
}
