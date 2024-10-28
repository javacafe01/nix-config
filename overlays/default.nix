# This file defines overlays
{inputs}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    stable = import inputs.nixos {inherit (prev) system config;};
    unstable = import inputs.nixpkgs {inherit (prev) system config;};
    master = import inputs.master {inherit (prev) system config;};
    old = import inputs.nixos-old {inherit (prev) system config;};

    broken = import inputs.nixpkgs {
      inherit (prev) system;
      config = prev.config // {allowBroken = true;};
    };
  };
}
