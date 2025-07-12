{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  username = "whoispiria";
  homeDirectory = "/home/${username}";
  thorium-browser = import ../../modules/nixos/thorium.nix { inherit pkgs lib; };
in

{
  programs.home-manager = {
    enable = true;
  };

  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
    inputs.ghostty.packages.x86_64-linux.default
    telegram-desktop
    spotify
    cantarell-fonts
    noto-fonts
    noto-fonts-emoji
    vlc
    zip
    vulkan-loader
    vulkan-validation-layers
    libglvnd
    nerd-fonts.code-new-roman
    libreoffice-still
    thorium-browser
    qbittorrent
    playerctl
    wineWowPackages.stable
    winetricks
    whitesur-kde
  ];

  home.file = {
    "${homeDirectory}/.config/chromium-flags.conf" = {
      text = ''
        --enable-features=UseOzonePlatform --ozone-platform=wayland
      '';
      executable = false;
    };
  };

  services.flameshot = {
    enable = true;
    package = pkgs.flameshot.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "flameshot-org";
        repo = "flameshot";
        rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
        sha256 = "sha256-OLRtF/yjHDN+sIbgilBZ6sBZ3FO6K533kFC1L2peugc=";
      };
      cmakeFlags = [
        "-DUSE_WAYLAND_CLIPBOARD=1"
        "-DUSE_WAYLAND_GRIM=1"
      ];
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.libsForQt5.kguiaddons ];
    });
    settings.General = {
      showStartupLaunchMessage = false;
      saveLastRegion = true;
      showDesktopNotification = false;
      jpegQuality = 100;
    };
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
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
    TERM = "ghostty";
    LD_LIBRARY_PATH = "~/local/lib:$LD_LIBRARY_PATH";
    MANPATH = "~/local/share/man:$MANPATH";
    COLORTERM = "truecolor";
    NVM_DIR = "~/.nvm";
    XCURSOR_SIZE = 34;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "kde";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;
    GDK_BACKEND = "wayland,x11,*";
    __GL_VRR_ALLOWED = 0;
    CLUTTER_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = 1;
    WLR_XWAYLAND_FORCE_VSYNC = 0;
  };

  programs.kitty.enable = true; # required for the default Hyprland config

  # Fix for KDE settings for Plasma 6: https://github.com/nix-community/home-manager/issues/5098#issuecomment-2352172073
  xdg.configFile."menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  qt = {
    enable = true;
    platformTheme.package = with pkgs.kdePackages; [
      plasma-integration
      systemsettings
    ];
    style = {
      package = pkgs.kdePackages.breeze;
      name = "Breeze";
    };
  };
  systemd.user.sessionVariables = { QT_QPA_PLATFORMTHEME = "kde"; };

  nix.settings.trusted-users = [ "whoispiria" ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "thorium-browser.desktop" ];
    "text/xml" = [ "thorium-browser.desktop" ];
    "x-scheme-handler/http" = [ "thorium-browser.desktop" ];
    "x-scheme-handler/https" = [ "thorium-browser.desktop" ];
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.whitesur-gtk-theme.overrideAttrs (oldAttrs: {
        nautilusStyle = "glassy";
      });
      name = "WhiteSur";
    };

    cursorTheme = {
      package = pkgs.whitesur-cursors;
      name = "WhiteSur Cursors";
    };

    iconTheme = {
      package = pkgs.whitesur-icon-theme;
      name = "WhiteSur";
    };
  };
}
