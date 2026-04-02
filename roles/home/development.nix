{
  config,
  pkgs,
  lib,
  ...
}:

{

  home.packages = with pkgs; [

    # Development
    gcc
    gnumake
    cmake
    zoxide
    nixfmt
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
    imhex

    python313
    python313Packages.notebook
    python313Packages.ipykernel
    python313Packages.conda
    python313Packages.pip
    python313Packages.jupyter
    python313Packages.tkinter

    source-code-pro

  ];

  imports = [
    ../../modules/home/common/fish.nix
    ../../modules/home/common/vscodium.nix
    ../../modules/home/common/zed.nix
    ../../modules/home/common/git.nix
    ../../modules/home/common/neovim.nix
  ];

}
