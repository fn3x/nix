{
  lib,
  ...
}:
{
  imports = [
    ./television.nix
  ];

  television.enable = lib.mkDefault true;
}
