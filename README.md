# nixos-pub

My public NixOS + nix-darwin work.

If you are an agent (or want machine-navigable docs), start with [AGENTS.md](AGENTS.md) — it is the verified, kept-current reference. This README only gives the overview.

## Features

- niri desktop on framework (sway config kept as an inactive alternative)
- Hibernation to disk with encrypted swap
- Self-signed Secure Boot via lanzaboote
- Secrets via sops-nix
- System hardening via nix-mineral, hardened ssh, run0 with sudo shim
- flake-native agent tooling: `nix fmt`, `nix run .#check`, on-demand devShell via `nix develop`

## Directory Structure

```
.
├── flake.nix
├── lib/           # mkHost / mkDarwinHost builders
├── hosts/         # per-device config (framework, proxmox, mbp)
├── roles/         # composed sets of modules
│   ├── system/    # nixos-level roles
│   └── home/      # home-manager roles
├── modules/       # individual building blocks
│   ├── system/    # nixos modules
│   └── home/      # home-manager modules
├── users/         # per-user home.nix
└── secrets/       # sops-encrypted yaml
```

## Import Hierarchy

```
flake.nix
│
├── framework (mkHost)
│   ├── hosts/framework/
│   ├── roles/system/base.nix
│   ├── roles/system/desktop-niri.nix   # niri is the active desktop
│   └── home-manager → users/michael/home.nix
│       ├── roles/home/desktop-niri.nix
│       └── roles/home/development.nix
│           └── (modules/home/**)
│
├── proxmox (mkHost)
│   ├── hosts/proxmox/
│   └── home-manager → users/michael/home-server.nix
│
└── mbp (mkDarwinHost)
    ├── hosts/mbp/
    └── home-manager → users/michael/home.nix
        ├── roles/home/development.nix
        └── modules/home/darwin/aerospace.nix
            └── (modules/home/**)
```

The sway roles (`roles/*/desktop-sway.nix`) are intentionally kept as an inactive alternative to niri.
