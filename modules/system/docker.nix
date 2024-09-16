{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    extraOptions = "--iptables=false";
  };
}
