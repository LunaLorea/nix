{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    merremia = {
      #url = "git+https://codeberg.org/lunalore/Merremia?ref=main";
      url = "path:/home/luna/Documents/Merremia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    merremia,
    ...
  } @ inputs: let
    colors = import ./colors.nix;

    recursiveImport = path: (import ./lib/recursiveImport.nix) nixpkgs path;

    mkHost = host:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs colors host merremia recursiveImport;
        };
        modules = [
          merremia.nixosModules.default
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

      server = mkHost {
        hostName = "server";
        userName = "luna";
      };
    };
  };
}
