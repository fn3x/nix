{
  lib,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./nu.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
    LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    MANPATH = "~/local/share/man:$MANPATH";
    COLORTERM = "truecolor";
    NVM_DIR = "~/.nvm";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
    XCURSOR_THEME = "Breeze";
    XCURSOR_SIZE = 34;
    GTK_THEME = "Breeze";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GDK_BACKEND = "wayland,x11,*";
    __GL_VRR_ALLOWED = 0;
    CLUTTER_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = 1;
    WLR_XWAYLAND_FORCE_VSYNC = 0;
    LIBVA_DRIVER_NAME = "nvidia";
    NIXOS_OZONE_WL = 1;
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    LIBVIRT_DEFAULT_URI="qemu:///system";
  };

  zsh.enable = lib.mkDefault false;
  nu.enable = lib.mkDefault false;
}
