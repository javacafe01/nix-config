{
  pkgs,
  config,
  ...
}: {
  programs.niri.config = import ./config.nix {inherit pkgs config;};
}
