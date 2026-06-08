{
lib,
config,
inputs,
pkgs,
...
}:
{
  options = {
    helium.enable = lib.mkEnableOption "enables helium";
  };

  config = lib.mkIf config.helium.enable {
    home.packages = [
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
