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

  home.sessionVariables = {
    EDITOR = "nvim";
    LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    MANPATH = "~/local/share/man:$MANPATH";
    COLORTERM = "truecolor";
    NVM_DIR = "~/.nvm";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
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
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    LIBVIRT_DEFAULT_URI="qemu:///system";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  home.shellAliases = {
    nix-s = "nh os switch -H desktop ~/nixos";
    nix-t = "nh os test  -H desktop ~/nixos";
    nix-c = "nh clean all";
    nix-u = "nh os switch -u -H desktop ~/nixos";
    vim = "nvim";
    vi = "nvim";
    nixdev= "nix develop --command nu -l";
  };

  home.sessionPath = [
    "~/go/bin/"
    "/usr/local/go/bin"
    "~/.local/bin"
    "/bin"
    "/sbin"
    "/usr/bin"
    "/usr/sbin"
    "/usr/local/bin"
    "/local/bin"
    "/lua-5.4.7"
    "~/local/lib"
    "OME/local/share/man"
    "~/perl5/bin"
    "/home/fn3x/.local/bin"
  ];
}
