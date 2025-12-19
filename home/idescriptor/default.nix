{
  lib,
  ...
}:
{
  imports = [
    ./idescriptor.nix
  ];

  idescriptor.enable = lib.mkDefault false;
}
