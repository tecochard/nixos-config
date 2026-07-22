{
  description = "Tortue's Nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Tracks the latest official OpenCode development build.
    opencode.url = "github:anomalyco/opencode/dev";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    opencode,
    ...
  }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          # Makes the OpenCode flake available inside home.nix.
          home-manager.extraSpecialArgs = {
            inherit opencode;
          };

          home-manager.users.theoe = {
            imports = [
              plasma-manager.homeModules.plasma-manager
              ./home.nix
            ];
          };
        }
      ];
    };
  };
}
