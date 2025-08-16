{
  description = "Nixos config flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    

  };
  
  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  } @ inputs: 

  let
    colors = import ./colors.nix;

    mkHost = host: nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs colors host;
      };
      modules = [
        ./hosts/${host.hostName}
        ./configuration.nix
      ];
    };      
  in {
    nixosConfigurations = {

      framework13 = mkHost {
        hostName = "framework13";
        userName = "luna";
      };

      desktop = mkHost {
        hostName = "desktop";
        userName = "luna";
      };

    };
  };
}
