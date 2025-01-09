{
  lib,
  pkgs,
  ...
}: {
  xsession = {
    enable = true;

    windowManager = {
      awesome = {
        enable = true;

        luaModules = lib.attrValues {
          inherit (pkgs.luajitPackages) lgi ldbus luadbi-mysql luaposix;
        };
      };
    };
  };
}
