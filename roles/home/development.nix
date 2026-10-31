{
  pkgs,
  lib,
  ...
}:

let
  # Loose `python3Packages.*` entries in home.packages end up in the profile's
  # site-packages but never on the interpreter's sys.path, so the Jupyter
  # extension cannot import ipykernel/notebook. Build one withPackages env
  # instead and let it provide `/etc/profiles/per-user/<user>/bin/python3`.
  pythonPackages = ps: [
    ps.ipykernel
    ps.ipywidgets
    ps.jupyter
    ps.notebook

    ps.matplotlib
    ps.numpy
    ps.openpyxl
    ps.pandas
    ps.scikit-learn
    ps.scipy
    ps.seaborn
    ps.sympy
  ];
in
{

  home.packages =
    with pkgs;
    [

      gcc
      gnumake
      tlrc
      cmake
      statix
      nix-output-monitor
      nh
      nixfmt
      ruff
      deadnix
      nil
      nixd
      gh
      ripgrep
      fd
      curl
      wget
      tree
      xcp
      rustc
      cargo
      bat
      unzip
      sops
      age

    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      imhex
      kicad

      (python313.withPackages (
        ps:
        pythonPackages ps
        ++ [
          ps.pip
          ps.tkinter
        ]
      ))
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      (python314.withPackages (
        ps:
        pythonPackages ps
        ++ [
          ps.pip
        ]
      ))
    ];

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  imports = [
    ../../modules/home/shell/fish.nix
    ../../modules/home/shell/git.nix
    ../../modules/home/editors/vscodium.nix
    ../../modules/home/editors/opencode.nix
    ../../modules/home/editors/pi.nix
    ../../modules/home/editors/neovim.nix
  ];

}
