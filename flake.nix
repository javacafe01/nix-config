{
  description = "javacafe's nix config";

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
       homelab = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/homelab/configuration.nix
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
              users.gokulswam.imports = [(./. + "/home-manager/javacafe@nixos-wsl/home.nix")];
            };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint

    homeConfigurations = {
      "javacafe@framework" = home.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};

        modules = [
          (./. + "/home-manager/javacafe@framework/home.nix")
        ];
      };
    };
  };

  inputs = {
    # Nixpkgs Repos
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixpkgs-unstable";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

    ghostty = {
      type = "github";
      owner = "ghostty-org";
      repo = "ghostty";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };

    home = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      type = "github";
      owner = "nix-community";
      repo = "nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      type = "github";
      owner = "nix-community";
      repo = "nix-vscode-extensions";
    };

    nixcord = {
      type = "github";
      owner = "kaylorben";
      repo = "nixcord";
    };

    nixgl = {
      type = "github";
      owner = "nix-community";
      repo = "nixGL";
    };

    nixpkgs-f2k = {
      type = "github";
      owner = "fortuneteller2k";
      repo = "nixpkgs-f2k";
    };

    nixos-wsl = {
      type = "github";
      owner = "nix-community";
      repo = "NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      type = "github";
      owner = "nix-community";
      repo = "nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      type = "github";
      owner = "danth";
      repo = "stylix";
    };

    vscode-server = {
      type = "github";
      owner = "nix-community";
      repo = "nixos-vscode-server";
    };

    # Other Non-flake Inputs
    sfmonoNerdFontLig-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };
}
