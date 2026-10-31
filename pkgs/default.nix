{ pkgs }:
{
  usbtree = pkgs.callPackage ./usbtree/package.nix { };
  audacity4 = pkgs.callPackage ./audacity4/package.nix { };
  bblauncher = pkgs.callPackage ./bblauncher/package.nix { };
}
