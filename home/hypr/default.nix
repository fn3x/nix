{
  lib,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./hyprpanel.nix
  ];

  hyprland.enable = lib.mkDefault false;
  hyprpanel.enable = lib.mkDefault false;
}
