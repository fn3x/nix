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
    ./bblauncher.nix
  ];

  shadps4.enable = lib.mkDefault false;
  lutris.enable = lib.mkDefault false;
  bblauncher.enable = lib.mkDefault false;
  home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks
  ];
}
