{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.determinate.nixosModules.default
    inputs.vscode-server.nixosModules.default

    ../shared/configuration.nix
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";

    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions

      inputs.nixpkgs-f2k.overlays.stdenvs

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;
  };

  programs.dconf.enable = true;

  services = {
    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    openssh = {
      enable = true;
      ports = [22];

      settings = {
        PasswordAuthentication = true;
        AllowUsers = null;
        UseDns = true;
        X11Forwarding = true;
      };
    };

    vscode-server.enable = true;
  };

  system.stateVersion = "24.11";
  time.hardwareClockInLocalTime = true;
  users.defaultUserShell = pkgs.lib.mkForce pkgs.bash;
}
