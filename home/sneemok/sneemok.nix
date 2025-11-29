{
lib,
config,
...
}:
{
  options = {
    sneemok.enable = lib.mkEnableOption "enables sneemok";
  };

  config = lib.mkIf config.sneemok.enable {
    services.sneemok.enable = true;
  };
}
