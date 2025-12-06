{
  lib,
  ...
}:
{
  imports = [
    ./dankmaterial.nix
  ];

  dankmaterial.enable = lib.mkDefault false;
}
