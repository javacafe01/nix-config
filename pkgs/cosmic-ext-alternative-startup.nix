{
  lib,
  craneLib,
  src,
  version,
  ...
}:
craneLib.buildPackage {
  pname = "cosmic-ext-alternative-startup";

  inherit version;
  inherit src;

  meta = with lib; {
    description = "Alternative startup script for Cosmic desktop extensions";
    homepage = "https://github.com/Drakulix/cosmic-ext-alternative-startup";
    license = licenses.mit;
    maintainers = with maintainers; [drakulix];
  };
}
