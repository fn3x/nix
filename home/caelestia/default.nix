{
  lib,
  ...
}:
{
  imports = [
    ./caelestia.nix
  ];

  caelestia.enable = lib.mkDefault false;
}
