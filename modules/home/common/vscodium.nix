{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode; # TODO move back to vscodium package
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      jnoortheen.nix-ide
      gruntfuggly.todo-tree
      rust-lang.rust-analyzer
      llvm-vs-code-extensions.vscode-clangd
      ms-toolsai.jupyter
      ms-python.python
      ms-vscode.cpptools

      ms-vscode-remote.remote-ssh # TODO move to open source remote ssh
    ];

    profiles.default.userSettings = {
      "workbench.colorTheme" = "Catppuccin Mocha";

      "telemetry.telemetryLevel" = "off";
      "telemetry.enableCrashReporter" = false;
      "telemetry.enableTelemetry" = false;
      "redhat.telemetry.enabled" = false;

      "editor.formatOnSave" = true;
      "editor.tabSize" = 4;
      "editor.stickyScroll.enabled" = false;
      "editor.minimap.enabled" = false;
      "breadcrumbs.enabled" = false;

      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "git.confirmSync" = false;

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";

      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };

      "[nix]" = {
        "editor.tabSize" = 4;
      };
    };
  };
}
