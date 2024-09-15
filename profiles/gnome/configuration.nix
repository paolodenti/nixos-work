# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, sops-nix, hostname, timezone, username, fullname, ... }:

{
  imports =
    [
      (../../. + "/hosts" + ("/" + hostname) + "/hardware-configuration.nix")
      (../../. + "/hosts" + ("/" + hostname) + "/disko-config.nix")
      (../../. + "/hosts" + ("/" + hostname) + "/bootloader.nix")
    ];

  # enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # docker
  virtualisation.docker = {
    enable = true;
    extraOptions = "--iptables=false";
  };

  # networking
  networking.hostName = hostname;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
    zsh
    sops
    age
    dconf2nix
    gnumake42
    kubectl
    stern
    helm
    k9s
    jq
    doctl
    zip
    unzip
  ];

  programs = {
    zsh = {
      enable = true;
    };
    firefox = {
      enable = true;
    };
  };

  # List services that you want to enable:

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
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAt/0brzr0xGFpaAgCAhNNXPj3EuCfmFndxyKlH/uLMnre9y6RzSOxHNJbiJy+jdkKsPv2zvISwnf7Z9Mv7rCZElRd9EKVZ7YZNVE02zfQCK/qEbhttacVvDEuPps55Mwywih+YlslsVq+UJ2I7Cyk6tnHuSXlV54qFi9kPeONwdtI9/tnYkpcpUzmFWWlHOcLPWgTM/8hczDCGSwTbQj+KHKKI9Wv5pCifPrgJQtPUeZV2Qqb+1ksxgNX841APdjUVDnZyuNa7Rd6+8WBWXt9I/wHVFzB5gTa08fsbeYOjaJ5Pg7oLYIKfJKKJaQ6jgOcU4eVCDJTscjxHms36vpK1w== pd@pdmac" ];
        packages = with pkgs; [
        ];
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
