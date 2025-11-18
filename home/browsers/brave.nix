{
lib,
config,
...
}:
{
  options = {
    brave.enable = lib.mkEnableOption "enables brave";
  };

  config = lib.mkIf config.brave.enable {
    programs.brave = {
      enable = true;
      commandLineArgs = [
        "--password-store=basic"
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "brave.desktop" ];
      "text/xml" = [ "brave.desktop" ];
      "x-scheme-handler/http" = [ "brave.desktop" ];
      "x-scheme-handler/https" = [ "brave.desktop" ];
    };
  };
}
