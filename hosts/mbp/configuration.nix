{ config, pkgs, ... }:

{

  imports = [ ./secrets.nix ];

  system.stateVersion = 4;
  system.primaryUser = "michael";
  networking.hostName = "mbp";
  nixpkgs.config.allowUnfree = true;
  environment.shells = [ pkgs.fish ];
  users.users.michael = {
    name = "michael";
    home = "/Users/michael";
    shell = pkgs.fish;
  };
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  system.defaults = {
    dock = {
      autohide = true;
      mineffect = "scale";
      autohide-delay = 0.0;
      autohide-time-modifier = 0.1;
      mru-spaces = false; # don't rearrange spaces by recent use
      show-recents = true; # hide recent apps section
      tilesize = 48; # icon size
      orientation = "left";
      persistent-apps = [
        "/Applications/Safari.app"
        "/Users/michael/Applications/Home Manager Apps/VSCodium.app"
        "/System/Applications/Utilities/Terminal.app"
        "/System/Applications/Utilities/Activity Monitor.app"
        "/System/Applications/iPhone Mirroring.app"
        "/System/Applications/System Settings.app"
      ];
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      AppleShowScrollBars = "WhenScrolling";
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      InitialKeyRepeat = 15; # faster key repeat
      KeyRepeat = 2;
      NSDocumentSaveNewDocumentsToCloud = false;
      "com.apple.swipescrolldirection" = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowStatusBar = true;
      ShowPathbar = true;
      _FXSortFoldersFirst = true;
      _FXShowPosixPathInTitle = true;
      FXPreferredViewStyle = "Nlsv"; # list view
      FXEnableExtensionChangeWarning = false;
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file://${builtins.getEnv "HOME"}/";
    };

    CustomUserPreferences = {

      NSGlobalDomain = {
        # Add a context menu item for showing the Web Inspector in web views
        WebKitDeveloperExtras = true;
      };
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };

      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "64" = {
            # Spotlight search
            enabled = false;
          };
          "65" = {
            # Spotlight window
            enabled = false;
          };
        };
      };
    };
  };

  launchd.user.agents = {
    aerospace = {
      serviceConfig = {
        Label = "com.nikitabobko.AeroSpace";
        ProgramArguments = [ "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
    raycast = {
      serviceConfig = {
        Label = "com.raycast.macos";
        ProgramArguments = [ "/Applications/Raycast.app/Contents/MacOS/Raycast" ];
        RunAtLoad = true;
        KeepAlive = false; # Raycast manages its own lifecycle
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [

  ];

  fonts.packages = with pkgs; [
    source-code-pro
  ];

  homebrew = {
    enable = true;
    prefix = "/opt/homebrew";
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    brews = [
      "nmap"
    ];
    casks = [
      "aerospace"
      "raycast"
      "vlc"
      "stats"
      "tailscale-app"
      "syncthing-app"
      "iina"
      "discord"
      "adobe-creative-cloud"
      "lm-studio"
      "utm"
      "orcaslicer"
      "imazing"
      "imaging-edge"
      "tor-browser"
      "mac-monitor"
      "claude"
      "onlyoffice"
    ];
  };

  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  ids.gids.nixbld = 350;
}
