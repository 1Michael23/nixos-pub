# nixos-pub
My public NixOS work

## Design

Flake defines configurations for one linux laptop, one Macbook, and multiple servers

   One host folder per unique device

   Hosts import Roles (eg. development.nix server-minimal.nix)

         Roles import Modules (eg. graphical-sway.nix composed of packages,)

Flake configuration imports home.nix

    home.nix imports home roles and home modules

        home roles import home modules.




### todo 