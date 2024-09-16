{ config, pkgs, username, fullname, email, ... }:

{
  imports = [
    ../../modules/user/programs/home-manager.nix
    ../../modules/user/programs/bash.nix
    ../../modules/user/programs/vim.nix
    ../../modules/user/programs/git.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/" + username;

  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
}
