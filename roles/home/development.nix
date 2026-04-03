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
    ../../modules/home/shell/fish.nix
    ../../modules/home/shell/git.nix
    ../../modules/home/editors/vscodium.nix
    ../../modules/home/editors/zed.nix
    ../../modules/home/editors/neovim.nix
  ];

}
