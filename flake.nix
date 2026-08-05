{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-nightly.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    merremia = {
      #url = "git+https://codeberg.org/lunalore/Merremia?ref=main";
      url = "path:/home/luna/Projects/Merremia";
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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-nightly,
      home-manager,
      merremia,
      sops-nix,
      stylix,
      ...
    }@inputs:
    let
      colors = import ./colors.nix;

      recursiveImport = path: (import ./lib/recursiveImport.nix) nixpkgs path;

      mkHost =
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              colors
              host
              merremia
              recursiveImport
              ;
            pkgs-nightly = import nixpkgs-nightly {
              inherit (host)
                system
                ;
              # To use Chrome, we need to allow the
              # installation of non-free software.
              config.allowUnfree = true;
            };
            pkgs-stable = import nixpkgs-stable {
              inherit (host)
                system
                ;
              # To use Chrome, we need to allow the
              # installation of non-free software.
              config.allowUnfree = true;
            };
          };
          modules = [
            sops-nix.nixosModules.sops
            stylix.nixosModules.stylix
            ./hosts/${host.hostName}
            ./configuration.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        framework13 = mkHost {
          hostName = "framework13";
          userName = "luna";
          system = "x86_64-linux";
        };

        epitome = mkHost {
          hostName = "epitome";
          userName = "luna";
          system = "x86_64-linux";
        };

        desktop = mkHost {
          hostName = "desktop";
          userName = "luna";
          system = "x86_64-linux";
        };

        myriorama = mkHost {
          hostName = "myriorama";
          userName = "luna";
          system = "x86_64-linux";
        };
      };
    };
}
