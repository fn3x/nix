{
pkgs,
lib,
config,
...
}:
{
  options = {
    lutris.enable = lib.mkEnableOption "enables lutris";
  };

  config = lib.mkIf config.lutris.enable {
    home.packages = with pkgs; [
      lutris
    ];
  };
}
