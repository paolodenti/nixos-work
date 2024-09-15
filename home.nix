{ config, pkgs, username, fullname, email, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/" + username;

  home.stateVersion = "24.05";

  home.packages = [
    pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    CASE_SENSITIVE = "true";
  };

  # Programs
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -lA";
      sshpassword = "ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no";
      clear-nix-boot-menu = "sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    };
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "copyfile"
        "copypath"
        "history"
        "wd"
      ];
    };
    initExtra = ''
      DEFAULT_USER="$USER"
    '';
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      syntax on
    '';
  };

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = fullname;
    userEmail = email;
    extraConfig = {
      core = {
        editor = "vim";
      };
      push = {
        autoSetupRemote = "true";
        default = "current";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };


  # gnome natural scrolling
  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };
  };

}
