{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    qpwgraph
    pwvucontrol
    pavucontrol
    easyeffects

    bitwig-studio
    bespokesynth

    carla
    yabridge
    yabridgectl
  ];
}
