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
      package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
      systemd = {
        enable = true;
        autoStart = true;
      };
      settings = {
        favicon_service = "twenty"; # twenty | google | none
        font.size = 14;
        pop_to_root_on_close = false;
        search_files_in_root = false;
        theme.dark.name = "vicinae-dark";
        theme.light.name = "vicinae-light";
        launcher_window = {
          csd = true;
          opacity = 0.95;
          rounding = 10;
        };
      };
    };
  };
}
