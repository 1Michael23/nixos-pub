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
      set -gx PATH $HOME/.local/bin /opt/homebrew/bin $PATH
      set -gx SOPS_AGE_KEY_FILE ~/.config/sops/age/keys.txt
    '';
    shellAliases = {
      ll = "ls -la";
      la = "ls -A";
    };
    plugins = [
      {
        name = "grc";
        inherit (pkgs.fishPlugins.grc) src;
      }
    ];

  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = lib.mkIf pkgs.stdenv.isLinux {
    # NOTE broken on nix-darwin temporarily
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$nix_shell$cmd_duration$character";

      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = "dimmed yellow";
      };

      nix_shell = {
        symbol = "";
        format = "(nix) ";
        style = "dimmed blue";
      };

      directory = {
        style = "bold blue";
        truncation_length = 3;
        truncate_to_repo = false;
      };

      git_branch = {
        format = "($branch) ";
        style = "green";
        symbol = "";
      };

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };
    };
  };
}
