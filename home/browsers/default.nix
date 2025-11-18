{
  lib,
  ...
}:
{
  imports = [
    ./brave.nix
  ];

  brave.enable = lib.mkDefault true;
}
