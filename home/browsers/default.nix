{
  lib,
  ...
}:
{
  imports = [
    ./helium.nix
  ];

  helium.enable = lib.mkDefault false;
}
