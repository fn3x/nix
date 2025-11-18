{
  lib,
  ...
}:
{
  imports = [
    ./river.nix
  ];

  river.enable = lib.mkDefault false;
}
