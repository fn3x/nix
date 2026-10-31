
{
pkgs,
lib,
config,
...
}:
{
  options = {
    bblauncher.enable = lib.mkEnableOption "enables bblauncher";
  };

  config = lib.mkIf config.bblauncher.enable {
    home.packages = [
      pkgs.bblauncher
    ];
  };
}
