{
pkgs,
lib,
config,
...
}:
let
  shadps4 = pkgs.kdePackages.callPackage ../../modules/games/shadps4/shadps4.nix {
    withGUI = true;
  };
in
{
  options = {
    shadps4.enable = lib.mkEnableOption "enables shadps4";
  };

  config = lib.mkIf config.shadps4.enable {
    home.packages = [
      shadps4
    ];
  };
}
