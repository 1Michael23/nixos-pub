{ config, pkgs, ... }:

{
  system.stateVersion = 4;
  system.primaryUser = "michael";
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
      autohide-time-modifier = 0.2;
      mru-spaces = false; # don't rearrange spaces by recent use
      show-recents = true; # hide recent apps section
      tilesize = 48; # icon size
      orientation = "left";
      persistent-apps = [
        # pin specific apps to dock
        "/Applications/Safari.app"
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
      InitialKeyRepeat = 15; # faster key repeat
      KeyRepeat = 2;
      NSDocumentSaveNewDocumentsToCloud = false;
      "com.apple.swipescrolldirection" = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowStatusBar = true;
      ShowPathbar = true;
      _FXSortFoldersFirst = true;
      FXPreferredViewStyle = "Nlsv"; # list view
      FXEnableExtensionChangeWarning = false;
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file://${builtins.getEnv "HOME"}/";
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [

  ];

  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    casks = [
      "vlc"
      "stats"
      "tailscale"
    ];
  };

  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  ids.gids.nixbld = 350;
}
