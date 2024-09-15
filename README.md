# NixOS - Flakes WIP

- Boot from a minimal iso
- `sudo su`
- `nix-shell -p git vim`
- `git clone https://github.com/paolodenti/nixos-work.git && cd nixos-work`
- `nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/<the host>/disko-config.nix`
- if a new host, execute the steps below
- `mkdir -p /mnt/etc/nixos`
- `cp -r * /mnt/etc/nixos/.`
- `nixos-install --root /mnt --flake '/mnt/etc/nixos/#<the host>`
- ctrl-d, ctrl-d, `
shutdown -h now`

## At the first login, run home manger

- login using `password` as password
- open a new terminal
- `home-manager switch --flake /etc/nixos`

## Adding a new host to the flake

If you are building a new host and you need to generate a new hardware configuration

- duplicate one of the existing hosts
- generate the hardware configuration for the current host

```
mkdir /tmp/hw
sudo nixos-generate-config --no-filesystems --root /tmp/hw
```

- Copy the new hardware configuration into the new host folder
- fix the partitioning scheme in `disko-config.nix`
- adjst `bootloader.nix` if needed
