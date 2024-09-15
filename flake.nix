{
  description = "Booter flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ...}:
    let
      # -- system settings -- #
      system = "x86_64-linux";
      profile = "personal";
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
          modules = [ (./. + "/profiles" + ("/" + profile) + "/configuration.nix") ];
          specialArgs = {
            inherit hostname;
            inherit timezone;
          };
        };
      };

      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ (./. + "/profiles" + ("/" + profile) + "/home.nix") ];
          extraSpecialArgs = {
            inherit username;
            inherit fullname;
            inherit email;
          };
        };
      };
    };
}
