{
  description = "javacafe's nix config";

  inputs = {
    # Nixpkgs Repos
    nixos-old.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    master.url = "github:nixos/nixpkgs";

    # Other Flake Inputs
    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home";
      };
    };

    crane.url = "github:ipetkov/crane";
    ghostty.url = "github:ghostty-org/ghostty";

    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake.url = "github:sodiboo/niri-flake";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixgl.url = "github:nix-community/nixGL";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
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
    nix-index-database,
    nix-on-droid,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs inputs;}
    );

    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # Nix-On-Droid (Termux, but Nix)
    nixOnDroidConfigurations = {
      nix-on-droid = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";

          overlays = [
            outputs.overlays.modifications
            outputs.overlays.additions
          ];
        };

        extraSpecialArgs = {inherit inputs outputs;};

        modules = [
          ./nixos/nix-on-droid/configuration.nix
          nix-index-database.nixosModules.nix-index
        ];
      };
    };

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/nixos-wsl/configuration.nix

          home.nixosModules.home-manager
          nix-index-database.nixosModules.nix-index

          {
            home-manager = {
              extraSpecialArgs = {inherit inputs outputs;};
              users.javacafe.imports = [(./. + "/home-manager/javacafe@nixos-wsl/home.nix")];
            };
          }
        ];
      };

      framework = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/framework/configuration.nix
          home.nixosModules.home-manager
          nix-index-database.nixosModules.nix-index

          {
            home-manager = {
              backupFileExtension = "hm-back1";
              extraSpecialArgs = {inherit inputs outputs;};
              users.javacafe.imports = [(./. + "/home-manager/javacafe@framework/home.nix")];
            };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "javacafe@nixos-wsl" = home.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          (./. + "/home-manager/javacafe@nixos-wsl/home.nix")
        ];
      };

      "javacafe@fw-fedora" = home.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          (./. + "/home-manager/javacafe@fw-fedora/home.nix")
          nix-index-database.hmModules.nix-index
        ];
      };

      "javacafe@ubuntu-wsl" = home.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          (./. + "/home-manager/javacafe@ubuntu-wsl/home.nix")
        ];
      };
    };
  };
}
