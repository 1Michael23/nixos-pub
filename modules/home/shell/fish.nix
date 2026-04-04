{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [ grc ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set -gx PATH /opt/homebrew/bin $PATH
    '';
    shellAliases = {
      ll = "ls -la";
      la = "ls -A";
    };
    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
      git_branch.symbol = " ";
      directory.truncation_length = 3;
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };
}
