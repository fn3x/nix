{
  lib,
  ...
}:
{
  imports = [
    ./noctalia.nix
  ];

  noctalia.enable = lib.mkDefault false;
}
