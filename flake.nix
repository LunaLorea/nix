{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    merremia = {
      url = "git+https://codeberg.org/lunalore/Merremia?ref=main";
      #url = "path:/home/luna/Documents/Merremia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    unmanic-nix = {
      url = "github:psoewish/unmanic-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    merremia,
    sops-nix,
    stylix,
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
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
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

      myriorama = mkHost {
        hostName = "myriorama";
        userName = "luna";
      };
    };
  };
}
