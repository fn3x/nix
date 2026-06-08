{
  lib,
  ...
}:
{
  imports = [
    ./brave.nix
    ./helium.nix
  ];

  brave.enable = lib.mkDefault false;
  helium.enable = lib.mkDefault false;
}
