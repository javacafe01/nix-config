{
  pkgs ? (import ../nixpkgs.nix) {},
  inputs,
}: {
  cosmic-ext-alternative-startup = pkgs.callPackage ./cosmic-ext-alternative-startup.nix {
    inherit (pkgs) lib;
    craneLib = inputs.crane.mkLib pkgs;
    src = inputs.cosmic-ext-alternative-startup-src;
    version = "999-master";
  };

  sfmonoNerdFontLig = pkgs.callPackage ./sfmonoNerdFontLig.nix {
    src = inputs.sfmonoNerdFontLig-src;
    version = "999-master";
  };
}
