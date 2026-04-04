{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isLinux {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=michael" ];
    };
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
