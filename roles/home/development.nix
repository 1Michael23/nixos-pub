{
  config,
  pkgs,
  lib,
  ...
}:

{

  home.packages =
    with pkgs;
    [

      gcc
      gnumake
      tlrc
      cmake
      zoxide
      statix
      nix-output-monitor
      nh
      nixfmt
      semgrep
      ruff
      deadnix
      nil
      nixd
      grc
      gh
      ripgrep
      fd
      curl
      wget
      tree
      rustc
      cargo
      bat
      unzip
      fastfetch
      source-code-pro
      sops
      age

      claude-code

      exiftool

    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      imhex

      python313
      python313Packages.notebook
      python313Packages.ipykernel
      #python313Packages.conda
      python313Packages.pip
      python313Packages.jupyter
      python313Packages.tkinter
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      python314
      python314Packages.notebook
      python314Packages.ipykernel
      python314Packages.pip
      python314Packages.jupyter
    ];

  imports = [
    ../../modules/home/shell/fish.nix
    ../../modules/home/shell/git.nix
    ../../modules/home/editors/vscodium.nix
    ../../modules/home/editors/zed.nix
    ../../modules/home/editors/neovim.nix
  ];

}
