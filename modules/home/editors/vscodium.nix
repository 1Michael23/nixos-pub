{
  config,
  lib,
  pkgs,
  vscodeExtensions,
  ...
}:

let
  noctaliaThemePath = "${config.home.homeDirectory}/.local/state/noctalia/vscode/NoctaliaTheme-color-theme.json";

  noctaliaVscodeTheme =
    pkgs.runCommand "noctalia-vscode-theme"
      {
        vscodeExtUniqueId = "noctalia.noctaliatheme-0.0.5";
        vscodeExtPublisher = "noctalia";
        version = "0.0.5";
      }
      ''
        ext="$out/share/vscode/extensions/noctalia.noctaliatheme-0.0.5"
        mkdir -p "$ext/themes"
        cat > "$ext/package.json" <<'EOF'
        {
          "name": "noctaliatheme",
          "displayName": "NoctaliaTheme",
          "description": "Noctalia Shell color theme",
          "publisher": "noctalia",
          "version": "0.0.5",
          "engines": { "vscode": "^1.60.0" },
          "contributes": {
            "themes": [
              {
                "label": "NoctaliaTheme",
                "uiTheme": "vs-dark",
                "path": "./themes/NoctaliaTheme-color-theme.json"
              }
            ]
          }
        }
        EOF
        ln -s ${lib.escapeShellArg noctaliaThemePath} "$ext/themes/NoctaliaTheme-color-theme.json"
      '';
in
{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      extensions =
        (
          with pkgs.vscode-extensions;
          [
            catppuccin.catppuccin-vsc
            jnoortheen.nix-ide
            gruntfuggly.todo-tree
            rust-lang.rust-analyzer
            llvm-vs-code-extensions.vscode-clangd
            ms-toolsai.jupyter
            ms-toolsai.jupyter-renderers
            ms-python.python
            ms-vscode.cpptools
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            mkhl.direnv
          ]
        )
        ++ (with vscodeExtensions.open-vsx; [
          jeanp413.open-remote-ssh
          sst-dev.opencode
        ])
        ++ [ noctaliaVscodeTheme ];

      userSettings = {
        "workbench.colorTheme" = "NoctaliaTheme";

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

        "todo-tree.general.statusBar" = "total";
        "todo-tree.general.tags" = [
          "BUG"
          "TODO"
          "CHECK"
          "NOTE"
        ];

      };
    };

    mutableExtensionsDir = false;
  };
}
