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
      git
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
      python313
      python313Packages.notebook
      python313Packages.ipykernel
      python313Packages.pip
      python313Packages.jupyter
    ];

  imports = [
    ../../modules/home/shell/fish.nix
    ../../modules/home/shell/git.nix
    ../../modules/home/editors/vscodium.nix
    ../../modules/home/editors/zed.nix
    ../../modules/home/editors/neovim.nix
  ];

}
