{
  description = "Booter flake";

  inputs = {
    # nixos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # sops
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, disko, ...}@inputs:
    let
      # -- system settings -- #
      system = "x86_64-linux";
      profile = "gnome";
      hostname = "macmini3";
      timezone = "America/Los_Angeles";

      # -- user settings -- #
      username = "pdenti";
      fullname = "Paolo Denti";
      email = "paolo.denti@gmail.com";

      # -- libs -- #
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        ${hostname} = lib.nixosSystem {
          inherit system;
          modules = [
            (./profiles + ("/" + profile) + "/configuration.nix")
            disko.nixosModules.disko
          ];
          specialArgs = {
            inherit inputs;
            inherit hostname;
            inherit timezone;
            inherit username;
            inherit fullname;
          };
        };
      };

      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./profiles + ("/" + profile) + "/home.nix")
          ];
          extraSpecialArgs = {
            inherit username;
            inherit fullname;
            inherit email;
          };
        };
      };
    };
}
