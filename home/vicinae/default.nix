{
  lib,
  ...
}:
{
  imports = [
    ./vicinae.nix
  ];

  vicinae.enable = lib.mkDefault false;
}
