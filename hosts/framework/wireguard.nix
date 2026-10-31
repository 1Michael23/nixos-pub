{
  config,
  pkgs,
  ...
}:

let
  profileFile = "wg0";
  profilePath = "/run/NetworkManager/system-connections/${profileFile}.nmconnection";
in
{
  # The whole NetworkManager keyfile is the `vpn-profile` sops secret declared
  # in hosts/framework/secrets.nix, so no endpoint or key material is in Nix.
  systemd.services.vpn-profile = {
    description = "Install the NetworkManager WireGuard profile";
    wantedBy = [ "multi-user.target" ];
    after = [ "NetworkManager.service" ];
    requires = [ "NetworkManager.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      UMask = "0077";
    };

    script = ''
      set -eu
      ${pkgs.coreutils}/bin/install -d -m 0700 /run/NetworkManager/system-connections
      ${pkgs.coreutils}/bin/install -m 0600 \
        ${config.sops.secrets."vpn-profile".path} \
        ${profilePath}
      # Empty permissions means every local user may read or modify the system
      # connection. Restrict it to michael before NetworkManager loads it.
      ${pkgs.gnused}/bin/sed -i '/^\[connection\]/a permissions=user:michael;' ${profilePath}
      ${config.networking.networkmanager.package}/bin/nmcli connection reload
      profileUuid="$(${pkgs.gnused}/bin/sed -n 's/^uuid=//p' ${profilePath})"
      for _ in 1 2 3 4 5; do
        if ${config.networking.networkmanager.package}/bin/nmcli connection show "$profileUuid" >/dev/null; then
          exit 0
        fi
        ${pkgs.coreutils}/bin/sleep 1
      done
      exit 1
    '';
  };

  # Useful for `run0 wg show` while debugging the tunnel.
  environment.systemPackages = [ pkgs.wireguard-tools ];
}
