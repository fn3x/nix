{
  lib,
  ...
}:
{
  imports = [
    ./sneemok.nix
  ];

  sneemok.enable = lib.mkDefault false;
}
