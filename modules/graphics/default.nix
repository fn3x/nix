{
  lib,
  ...
}:
{
  imports = [
    ./nvidia.nix
    ./intel.nix
  ];

  nvidia.enable = lib.mkDefault false;
  intel.enable = lib.mkDefault false;
}
