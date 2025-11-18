{
  lib,
  ...
}:
{
  imports = [
    ./nixvim.nix
  ];

  neovim.enable = lib.mkDefault false;
}
