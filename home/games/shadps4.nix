{
lib,
config,
inputs,
...
}:
{
  options = {
    shadps4.enable = lib.mkEnableOption "enables shadps4";
  };

  config = lib.mkIf config.shadps4.enable {
    home.packages = [
      inputs.shadps4.packages.x86_64-linux.shadps4
      inputs.shadps4.packages.x86_64-linux.shadps4-qt
    ];
  };
}
