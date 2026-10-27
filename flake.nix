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

    # Pin both the CLI and desktop app to the official OpenCode v2 release.
    opencode.url = "github:anomalyco/opencode/v2.2.0";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      opencode,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
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
