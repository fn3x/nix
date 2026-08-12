{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    rt.enable = lib.mkEnableOption "Enables realtime audio scheduling";
  };

  config = lib.mkIf config.rt.enable {
    security.rtkit.enable = true;

    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nice"; type = "-"; value = "-19"; }
    ];
  };
}
