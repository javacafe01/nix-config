{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  console.keyMap = "us";

  environment = {
    binsh = "${pkgs.bash}/bin/bash";
    shells = with pkgs; [zsh];

    systemPackages = lib.attrValues {
      inherit
        (pkgs)
        curl
        git
        home-manager
        libtool
        lm_sensors
        man-pages
        man-pages-posix
        unrar
        unzip
        sshpass
        vim
        wget
        xarchiver
        xclip
        zip
        ;
    };

    variables.EDITOR = "${pkgs.vim}/bin/vim";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      substituters = [
        "https://cache.nixos.org"
        "https://cache.ngi0.nixos.org"
        "https://nix-community.cachix.org"
        "https://fortuneteller2k.cachix.org"
        "https://cosmic.cachix.org"
        "https://ghostty.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];

      trusted-users = [
        "gokulswam"
      ];
    };
  };

  programs = {
    bash = {
      interactiveShellInit = ''
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      '';

      promptInit = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
    };

    command-not-found.enable = false;
    nix-index-database.comma.enable = true;
    nix-ld.enable = true;

    ssh = {
      forwardX11 = true;
      startAgent = true;
    };

    zsh = {
      enable = true;

      interactiveShellInit = ''
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      '';
    };
  };

  security.rtkit.enable = true;

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "America/Los_Angeles";
  };

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;

    users.gokulswam = {
      description = "gokulswam";
      isNormalUser = true;
      home = "/home/gokulswam";

      extraGroups = ["wheel" "networkmanager" "sudo" "video" "audio"];
    };
  };
}
