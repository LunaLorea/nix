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
    ...
  } @ inputs: 
  let
    colors = import ./colors.nix;
  in {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit colors;
      };
      modules = [
        ./hosts/laptop/hardware-configuration.nix
        ./hosts/laptop/laptop-config.nix
        ./configuration.nix
      ];
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        };
      modules = [
        ./hosts/desktop/hardware-configuration.nix
        ./hosts/desktop/desktop-config.nix
        ./nvidia.nix
        ./configuration.nix
      ];
    };

    nixosConfigurations.live = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
        ./hosts/laptop/configuration.nix
      ];
    };
  };
}
