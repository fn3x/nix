{
lib,
config,
inputs,
pkgs,
...
}:
{
  options = {
    vicinae.enable = lib.mkEnableOption "enables vicinae";
  };

  config = lib.mkIf config.vicinae.enable {
    services.vicinae = {
      enable = true;
      autoStart = true;
      package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        faviconService = "twenty"; # twenty | google | none
        font.size = 14;
        popToRootOnClose = false;
        rootSearch.searchFiles = false;
        theme.name = "vicinae-dark";
        window = {
          csd = true;
          opacity = 0.95;
          rounding = 10;
        };
      };
    };
  };
}
