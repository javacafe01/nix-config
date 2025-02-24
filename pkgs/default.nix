{
  pkgs ? (import ../nixpkgs.nix) {},
  inputs,
}: {
  sfmonoNerdFontLig = pkgs.callPackage ./sfmonoNerdFontLig.nix {
    src = inputs.sfmonoNerdFontLig-src;
    version = "999-master";
  };
}
