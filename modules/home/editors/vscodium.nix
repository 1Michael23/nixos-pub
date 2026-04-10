{
  config,
  lib,
  pkgs,
  vscodeExtensions,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;

    extensions =
      (with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        jnoortheen.nix-ide
        gruntfuggly.todo-tree
        rust-lang.rust-analyzer
        llvm-vs-code-extensions.vscode-clangd
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-python.python
        ms-vscode.cpptools
      ])
      ++ (with vscodeExtensions.open-vsx; [
        semgrep.semgrep
        jeanp413.open-remote-ssh
      ]);

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

      "semgrep.scan.onSave" = true;
      "semgrep.scan.configuration" = [ "~/dev/semgrep-rules" ];
      "semgrep.path" = "${pkgs.semgrep}/bin/semgrep";
      "semgrep.doLogin" = false;
      "semgrep.scan.onlyGitDirty" = false;
      "semgrep.metrics" = false;
    };
  };
}
