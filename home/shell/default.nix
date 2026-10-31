{
  lib,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./nu.nix
    ./fish.nix
  ];

  zsh.enable = lib.mkDefault false;
  nu.enable = lib.mkDefault false;
  fish.enable = lib.mkDefault false;

  # GPU-specific variables (GBM_BACKEND, LIBVA_DRIVER_NAME, ...) live in
  # modules/graphics so they only apply to the host with that GPU.
  home.sessionVariables = {
    EDITOR = "nvim";
    COLORTERM = "truecolor";
    GTK_THEME = "Breeze";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;
    NIXOS_OZONE_WL = 1;
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    NO_AT_BRIDGE = 1;
  };

  # nh picks the host from the hostname and the flake from programs.nh.flake
  home.shellAliases = {
    nix-s = "nh os switch";
    nix-b = "nh os boot";
    nix-t = "nh os test";
    nix-c = "nh clean all";
    nix-u = "nh os switch -u";
    vim = "nvim";
    vi = "nvim";
    nixdev = "nix develop --command nu -l";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/perl5/bin"
  ];
}
