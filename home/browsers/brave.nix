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
        "--ozone-platform=wayland"
      ];
    };

    # mkDefault: another browser module (helium) may take over
    xdg.mimeApps.defaultApplications = lib.mapAttrs (_: lib.mkDefault) {
      "text/html" = [ "brave.desktop" ];
      "text/xml" = [ "brave.desktop" ];
      "x-scheme-handler/http" = [ "brave.desktop" ];
      "x-scheme-handler/https" = [ "brave.desktop" ];
    };
  };
}
