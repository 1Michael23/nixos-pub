# nixos-pub

My public NixOS + nix-darwin work.

## Features

- Hibernation to disk with encrypted swap
- Self-signed Secure Boot via lanzaboote
- Secrets via sops-nix
- System hardening via nix-mineral, hardened ssh, run0 with sudo shim

## Resources

- [saylesss88's NixOS hardening guide](https://saylesss88.github.io/nix/hardening_NixOS.html) - Amazing security focused nix guide.
- [msyds/tf2-nix](https://gitlab.com/msyds/tf2-nix) — Declarative TF2 config

## Directory Structure

```
.
├── flake.nix
├── lib/           # mkHost / mkDarwinHost builders
├── hosts/         # per-device config (framework, mbp)
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
│   ├── roles/system/desktop-sway.nix
│   └── home-manager → users/michael/home.nix
│       ├── roles/home/development.nix
│       ├── roles/home/desktop-sway.nix
│       └── roles/home/pentesting.nix
│           └── (modules/home/**)
│
└── mbp (mkDarwinHost)
    ├── hosts/mbp/
    └── home-manager → users/michael/home.nix
        ├── roles/home/development.nix
        └── modules/home/darwin/aerospace.nix
            └── (modules/home/**)
```

