{
  lib,
  ...
}:
{
  imports = [
    ./tmux.nix
  ];

  tmux.enable = lib.mkDefault false;
}
