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

    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
      "x-scheme-handler/about" = [ "helium.desktop" ];
      "x-scheme-handler/unknown" = [ "helium.desktop" ];
    };
  };
}
