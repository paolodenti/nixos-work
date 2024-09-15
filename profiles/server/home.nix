{ config, pkgs, username, fullname, email, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/" + username;

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    SOPS_AGE_KEY_FILE="$HOME/.sops/age.txt";
    AGE_PUBLIC="$(cat $HOME/.sops/age.txt | grep -oP "public key: \K(.*)")";
  };

  # Programs

  programs.home-manager = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lA";
      sshpassword = "ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no";
      clear-nix-boot-menu = "sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    };
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
}
