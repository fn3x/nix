{
lib,
config,
...
}:
{
  options = {
    television.enable = lib.mkEnableOption "enables television";
  };

  config = lib.mkIf config.television.enable {
    programs.television = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
