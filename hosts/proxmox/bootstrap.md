## Proxmox

#### Bootstrap
```bash
nix-shell -p git --run 'git clone https://github.com/1Michael23/nixos-pub /tmp/cfg'
cd /tmp/cfg
nix --experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake .#proxmox
nixos-install --flake .#proxmox --no-root-passwd
```
#### Update
```bash
nh os switch --hostname proxmox --target-host michael@<ip>
```