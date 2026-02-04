
{
pkgs,
lib,
config,
...
}:
let
  bblauncher = import ../../modules/games/bblauncher.nix { inherit pkgs lib; };
in
{
  options = {
    bblauncher.enable = lib.mkEnableOption "enables bblauncher";
  };

  config = lib.mkIf config.bblauncher.enable {
    home.packages = [
      bblauncher
    ];
  };
}
