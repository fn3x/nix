{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./shadps4.nix
    ./lutris.nix
    ./prismlauncher.nix
  ];

  shadps4.enable = lib.mkDefault false;
  lutris.enable = lib.mkDefault false;
  home.packages = with pkgs; [
    wineWow64Packages.waylandFull
    winetricks
  ];
}
