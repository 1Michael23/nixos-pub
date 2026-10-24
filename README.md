# nixos-pub

My personal NixOS + nix-darwin configuration.

## Features

- Hibernation to disk with encrypted swap (framework)
- Self-signed Secure Boot via lanzaboote (framework)
- Secrets via sops-nix
- System hardening via nix-mineral and run0 sudo shim (framework), hardened ssh
- Niri + Noctalia Shell desktop on framework: bar, launcher, clipboard, notifications, OSD, lock/session, screenshots, and wallpaper-derived theming for GTK, Alacritty, and Niri
- flake-native developer tooling: `nix fmt`, `nix run .#check`, on-demand devShell via `nix develop`

## Directory Structure

```
.
├── flake.nix
├── flake.lock
├── .sops.yaml     # sops age recipient rules
├── lib/           # mkHost / mkDarwinHost builders
├── hosts/         # per-device config (framework, proxmox, mbp)
├── roles/         # composed sets of modules
│   ├── system/    # nixos-level roles
│   └── home/      # home-manager roles
├── modules/       # individual building blocks
│   ├── system/    # nixos modules
│   └── home/      # home-manager modules
├── users/         # per-user home configs
└── secrets/       # sops-encrypted yaml
```

## Import Hierarchy

```
# Simplified: not every imported module is shown.
flake.nix
│
├── framework (mkHost)
│   ├── hosts/framework/
│   ├── roles/system/base.nix
│   ├── roles/system/desktop-niri.nix
│   └── home-manager → users/michael/home.nix
│       ├── roles/home/development.nix
│       ├── roles/home/photography.nix
│       └── roles/home/desktop-niri.nix
│           ├── modules/home/desktop/niri/niri.nix
│           └── modules/home/desktop/noctalia.nix
│
├── proxmox (mkHost)
│   ├── hosts/proxmox/
│   ├── roles/system/base.nix
│   └── home-manager → users/michael/home-server.nix
│       └── roles/home/development.nix
│
└── mbp (mkDarwinHost)
    ├── hosts/mbp/
    └── home-manager → users/michael/home.nix
        ├── roles/home/development.nix
        ├── roles/home/photography.nix
        └── modules/home/darwin/aerospace.nix
```
