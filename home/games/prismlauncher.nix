{
pkgs,
lib,
config,
...
}:
{
  options = {
    prismlauncher.enable = lib.mkEnableOption "enables prismlauncher";
  };

  config = lib.mkIf config.prismlauncher.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
