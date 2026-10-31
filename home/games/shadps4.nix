{
lib,
config,
pkgs,
inputs,
...
}:
{
  options = {
    shadps4.enable = lib.mkEnableOption "enables shadps4";
  };

  config = lib.mkIf config.shadps4.enable {
    home.packages = [
      inputs.shadps4.packages.${pkgs.stdenv.hostPlatform.system}.shadps4
      inputs.shadps4.packages.${pkgs.stdenv.hostPlatform.system}.shadps4-qt
    ];
  };
}
