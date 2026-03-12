{
  lib,
  ...
}:
{
  imports = [
    ./niri.nix
  ];

  niri.enable = lib.mkDefault false;
}
