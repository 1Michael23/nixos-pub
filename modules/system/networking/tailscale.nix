{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isLinux {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both";
      extraSetFlags = [
        "--operator=michael"
        "--ssh"
      ];

    };
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    # IP forwarding for exit-node / subnet-router functionality:
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };
}
