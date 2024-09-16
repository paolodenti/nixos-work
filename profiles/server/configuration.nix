# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, hostname, timezone, username, fullname, ... }:

{
  imports = [
    (../../. + "/hosts" + ("/" + hostname) + "/hardware-configuration.nix")
    (../../. + "/hosts" + ("/" + hostname) + "/disko-config.nix")
    (../../. + "/hosts" + ("/" + hostname) + "/bootloader.nix")
    ../../modules/system/features.nix
    ../../modules/system/docker.nix
  ];

  # networking
  networking.hostName = hostname;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    vim
    curl
    wget
    git
    sops
    age
    dconf2nix
    gnumake42
    kubectl
    stern
    helm
    k9s
    jq
    zip
    unzip
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  # NixOS upgrades
  system.autoUpgrade.enable = true;

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  users = {
    mutableUsers = true;
    users = {
      ${username} = {
        isNormalUser = true;
        description = fullname;
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
        password = "password";
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAt/0brzr0xGFpaAgCAhNNXPj3EuCfmFndxyKlH/uLMnre9y6RzSOxHNJbiJy+jdkKsPv2zvISwnf7Z9Mv7rCZElRd9EKVZ7YZNVE02zfQCK/qEbhttacVvDEuPps55Mwywih+YlslsVq+UJ2I7Cyk6tnHuSXlV54qFi9kPeONwdtI9/tnYkpcpUzmFWWlHOcLPWgTM/8hczDCGSwTbQj+KHKKI9Wv5pCifPrgJQtPUeZV2Qqb+1ksxgNX841APdjUVDnZyuNa7Rd6+8WBWXt9I/wHVFzB5gTa08fsbeYOjaJ5Pg7oLYIKfJKKJaQ6jgOcU4eVCDJTscjxHms36vpK1w== pd@pdmac" ];
        shell = pkgs.bash;
        packages = with pkgs; [
        ];
      };
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
