{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isLinux {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=framework" ]; # TODO fix user dependency
    };
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
