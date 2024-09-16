{ config, pkgs, username, fullname, email, ... }:

{
  imports = [
    ../../modules/user/programs/home-manager.nix
    ../../modules/user/programs/zsh.nix
    ../../modules/user/programs/vim.nix
    ../../modules/user/programs/git.nix
    ../../modules/user/gnome
  ];

  home.username = username;
  home.homeDirectory = "/home/" + username;

  home.stateVersion = "24.05";

  home.packages = [
    # pkgs.hello

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

  home.file = {
    ".p10k.zsh".text = builtins.readFile ../../dotfiles/p10k.zsh;

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
}
