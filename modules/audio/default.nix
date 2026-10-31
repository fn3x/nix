{
  lib,
  ...
}:
{
  imports = [
    ./pipewire.nix
    ./realtime.nix
  ];

  pipewire.enable = lib.mkDefault true;
}
