{
  lib,
  ...
}:
{
  imports = [
    ./wofi.nix
  ];

  wofi.enable = lib.mkDefault false;
}
