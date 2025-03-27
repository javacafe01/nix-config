{
  description = "javacafe's nix config";

  inputs = {
    # Nixpkgs Repos
    nixos-old.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs";

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home";
      };
    };

    crane.url = "github:ipetkov/crane";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };

    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake.url = "github:sodiboo/niri-flake";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixcord.url = "github:kaylorben/nixcord";
    nixgl.url = "github:nix-community/nixGL";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    stylix.url = "github:danth/stylix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # Other Non-flake Inputs
    cosmic-ext-alternative-startup-src = {
      url = "github:Drakulix/cosmic-ext-alternative-startup";
      flake = false;
    };

    sfmonoNerdFontLig-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs inputs;}
    );

    # Devshell for bootstrapping
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint

    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/framework/configuration.nix
          home.nixosModules.home-manager

          {
            home-manager = {
              backupFileExtension = "hm-back";
              extraSpecialArgs = {inherit inputs outputs;};
              users.gokulswam.imports = [(./. + "/home-manager/gokulswam@framework/home.nix")];
            };
          }
        ];
      };

      nixos-wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/nixos-wsl/configuration.nix
          home.nixosModules.home-manager

          {
            home-manager = {
              backupFileExtension = "hm-back";
              extraSpecialArgs = {inherit inputs outputs;};
              users.javacafe.imports = [(./. + "/home-manager/gokulswam@nixos-wsl/home.nix")];
            };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint

    homeConfigurations = {
      "gokulswam@ubuntu-wsl" = home.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};

        modules = [
          (./. + "/home-manager/gokulswam@ubuntu-wsl/home.nix")
        ];
      };
    };
  };
}
