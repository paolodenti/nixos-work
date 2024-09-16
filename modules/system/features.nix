{ config, pkgs, ... }:

{
  # enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
