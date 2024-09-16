{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    extraConfig = ''
      syntax on
    '';
  };
}
