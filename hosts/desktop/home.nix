{
  inputs,
  config,
  pkgs,
  ...
}:

let
  username = "fn3x";
  homeDirectory = "/home/${username}";
  system = pkgs.stdenv.hostPlatform.system;
in

{
  programs.home-manager = {
    enable = true;
  };

  imports = [
    ../../home/neovim
    ../../home/ghostty
    ../../home/hypr
    ../../home/river
    ../../home/tmux
    ../../home/wofi
    ../../home/vicinae
    ../../home/shell
    ../../home/browsers
  ];

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
    inputs.hyprland-guiutils.packages.x86_64-linux.default
    inputs.apple-fonts.packages.${system}.sf-pro-nerd
    inputs.hyprpwcenter.packages.${system}.default
    oh-my-posh
    telegram-desktop
    mattermost-desktop
    cantarell-fonts
    noto-fonts
    noto-fonts-color-emoji
    fd
    ripgrep
    tmux
    vlc
    btop
    lazygit
    jq
    tldr
    zip
    dbeaver-bin
    mysql_jdbc
    openssl
    grim
    gamescope
    vulkan-loader
    vulkan-validation-layers
    libglvnd
    wofi
    nerd-fonts.code-new-roman
    inkscape
    libreoffice-still
    logmein-hamachi
    teamspeak6-client
    qbittorrent
    playerctl
    anydesk
    wineWow64Packages.waylandFull
    winetricks
    vesktop
    thunderbird
    r2modman
    whitesur-kde
    caligula
    postman
    prismlauncher
    wl-clipboard
    satty
    grim
    slurp
    helvum
    poop
    rustdesk-flutter
    gajim
    filezilla
    spotify
    signal-desktop
    srb2
    pinta
    cava
    mariadb.client
    freerdp
    bash
    kdePackages.breeze-icons
    kdePackages.breeze
    mullvad-browser
    nwg-displays
    normcap
  ];

  neovim.enable = true;
  hyprland.enable = true;
  hyprpanel.enable = true;
  vicinae.enable = true;
  ghostty.enable = true;
  nu.enable = true;
  brave.enable = true;

  home.file = {
    "${homeDirectory}/.config/uwsm/env-hyprland" = {
      text = ''
        export HYPRLAND_NO_SD_VARS=1
      '';
      executable = false;
    };
    "${homeDirectory}/.config/chromium-flags.conf" = {
      text = ''
        --enable-features=UseOzonePlatform --ozone-platform=wayland
      '';
      executable = false;
    };
    "${homeDirectory}/.config/electron-flags.conf" = {
      text = ''
        --enable-features=UseOzonePlatform --ozone-platform=wayland
      '';
      executable = false;
    };
    "${homeDirectory}/.cache/nvim/lazygit-theme" = {
      text = ''
      '';
      executable = false;
    };
    "${homeDirectory}/.config/winapps/winapps.conf" = {
      text = ''
##################################
#   WINAPPS CONFIGURATION FILE   #
##################################

# INSTRUCTIONS
# - Leading and trailing whitespace are ignored.
# - Empty lines are ignored.
# - Lines starting with '#' are ignored.
# - All characters following a '#' are ignored.

# [WINDOWS USERNAME]
RDP_USER="art"

# [WINDOWS PASSWORD]
# NOTES:
# - If using FreeRDP v3.9.0 or greater, you *have* to set a password
RDP_PASS="123"

# [WINDOWS DOMAIN]
# DEFAULT VALUE: (BLANK)
RDP_DOMAIN=""

# [WINDOWS IPV4 ADDRESS]
# NOTES:
# - If using 'libvirt', 'RDP_IP' will be determined by WinApps at runtime if left unspecified.
# DEFAULT VALUE:
# - 'docker': '127.0.0.1'
# - 'podman': '127.0.0.1'
# - 'libvirt': (BLANK)
RDP_IP="192.168.122.173"

# [VM NAME]
# NOTES:
# - Only applicable when using 'libvirt'
# - The libvirt VM name must match so that WinApps can determine VM IP, start the VM, etc.
# DEFAULT VALUE: 'RDPWindows'
VM_NAME="RDPWindows"

# [WINAPPS BACKEND]
# DEFAULT VALUE: 'docker'
# VALID VALUES:
# - 'docker'
# - 'podman'
# - 'libvirt'
# - 'manual'
WAFLAVOR="libvirt"

# [DISPLAY SCALING FACTOR]
# NOTES:
# - If an unsupported value is specified, a warning will be displayed.
# - If an unsupported value is specified, WinApps will use the closest supported value.
# DEFAULT VALUE: '100'
# VALID VALUES:
# - '100'
# - '140'
# - '180'
RDP_SCALE="100"

# [MOUNTING REMOVABLE PATHS FOR FILES]
# NOTES:
# - By default, `udisks` (which you most likely have installed) uses /run/media for mounting removable devices.
#   This improves compatibility with most desktop environments (DEs).
# ATTENTION: The Filesystem Hierarchy Standard (FHS) recommends /media instead. Verify your system's configuration.
# - To manually mount devices, you may optionally use /mnt.
# REFERENCE: https://wiki.archlinux.org/title/Udisks#Mount_to_/media
REMOVABLE_MEDIA="/run/media"

# [ADDITIONAL FREERDP FLAGS & ARGUMENTS]
# NOTES:
# - You can try adding /network:lan to these flags in order to increase performance, however, some users have faced issues with this.
#   If this does not work or if it does not work without the flag, you can try adding /nsc and /gfx.
# DEFAULT VALUE: '/cert:tofu /sound /microphone +home-drive'
# VALID VALUES: See https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown
RDP_FLAGS="/cert:tofu /sound /microphone +home-drive"

# [DEBUG WINAPPS]
# NOTES:
# - Creates and appends to ~/.local/share/winapps/winapps.log when running WinApps.
# DEFAULT VALUE: 'true'
# VALID VALUES:
# - 'true'
# - 'false'
DEBUG="true"

# [AUTOMATICALLY PAUSE WINDOWS]
# NOTES:
# - This is currently INCOMPATIBLE with 'manual'.
# DEFAULT VALUE: 'off'
# VALID VALUES:
# - 'on'
# - 'off'
AUTOPAUSE="off"

# [AUTOMATICALLY PAUSE WINDOWS TIMEOUT]
# NOTES:
# - This setting determines the duration of inactivity to tolerate before Windows is automatically paused.
# - This setting is ignored if 'AUTOPAUSE' is set to 'off'.
# - The value must be specified in seconds (to the nearest 10 seconds e.g., '30', '40', '50', etc.).
# - For RemoteApp RDP sessions, there is a mandatory 20-second delay, so the minimum value that can be specified here is '20'.
# - Source: https://techcommunity.microsoft.com/t5/security-compliance-and-identity/terminal-services-remoteapp-8482-session-termination-logic/ba-p/246566
# DEFAULT VALUE: '300'
# VALID VALUES: >=20
AUTOPAUSE_TIME="300"

# [FREERDP COMMAND]
# NOTES:
# - WinApps will attempt to automatically detect the correct command to use for your system.
# DEFAULT VALUE: (BLANK)
# VALID VALUES: The command required to run FreeRDPv3 on your system (e.g., 'xfreerdp', 'xfreerdp3', etc.).
FREERDP_COMMAND=""

# [TIMEOUTS]
# NOTES:
# - These settings control various timeout durations within the WinApps setup.
# - Increasing the timeouts is only necessary if the corresponding errors occur.
# - Ensure you have followed all the Troubleshooting Tips in the error message first.

# PORT CHECK
# - The maximum time (in seconds) to wait when checking if the RDP port on Windows is open.
# - Corresponding error: "NETWORK CONFIGURATION ERROR" (exit status 13).
# DEFAULT VALUE: '5'
PORT_TIMEOUT="5"

# RDP CONNECTION TEST
# - The maximum time (in seconds) to wait when testing the initial RDP connection to Windows.
# - Corresponding error: "REMOTE DESKTOP PROTOCOL FAILURE" (exit status 14).
# DEFAULT VALUE: '30'
RDP_TIMEOUT="30"

# APPLICATION SCAN
# - The maximum time (in seconds) to wait for the script that scans for installed applications on Windows to complete.
# - Corresponding error: "APPLICATION QUERY FAILURE" (exit status 15).
# DEFAULT VALUE: '60'
APP_SCAN_TIMEOUT="60"

# WINDOWS BOOT
# - The maximum time (in seconds) to wait for the Windows VM to boot if it is not running, before attempting to launch an application.
# DEFAULT VALUE: '120'
BOOT_TIMEOUT="120"

# FREERDP RAIL HIDEF
# - This option controls the value of the `hidef` option passed to the /app parameter of the FreeRDP command.
# - Setting this option to 'off' may resolve window misalignment issues related to maximized windows.
# DEFAULT VALUE: 'on'
HIDEF="on"

VIRSH_CONNECTION="qemu:///system"
      '';
      executable = false;
    };
    "${homeDirectory}/.config/niri/config.kdl" = {
      text = ''
input {
    keyboard {
        xkb {
            layout "us,ru"
            model "kinesis"
            options "grp:win_space_toggle"
        }

        repeat-delay 300
        repeat-rate 50
        track-layout "global"
        numlock
    }

    mouse {
        accel-speed 0
    }

    // disable-power-key-handling
    // warp-mouse-to-focus
    focus-follows-mouse max-scroll-amount="0%"
    // workspace-auto-back-and-forth

    mod-key "Alt"
    mod-key-nested "Super"
}

output "DP-1" {
    mode "2560x1440@170.00"
    scale 1.25
    position x=0 y=0
    focus-at-startup
}
binds {
    Mod+T repeat=false { spawn-sh "${pkgs.uwsm}/bin/uwsm app -- ${inputs.ghostty.packages.${system}.default}/bin/ghostty"; }
    Mod+Shift+Q { close-window; }
    Mod+M { quit; }
    Mod+E { spawn "${pkgs.kdePackages.dolphin}/bin/dolphin"; }
    Mod+V { toggle-window-floating; }
    Mod+SPACE { spawn-sh "${inputs.vicinae.packages.${system}.default}/bin/vicinae toggle"; }
    Mod+SHIFT+S { spawn-sh "XDG_CURRENT_DESKTOP=sway ${pkgs.flameshot}/bin/flameshot gui"; }
    Mod+F { fullscreen-window; }
    Win+Space { switch-layout; }
}
      '';
      executable = false;
    };
  };

  services.flameshot = {
    enable = true;
    package = pkgs.flameshot.override {
      enableWlrSupport = true;
    };
    settings.General = {
      showStartupLaunchMessage = false;
      saveLastRegion = true;
      showDesktopNotification = false;
      jpegQuality = 100;
    };
  };

  programs.gpg = {
    enable = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      vim_keys = true;
      update_ms = 100;
    };
  };

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
      name = "breeze";
    };
  };
  systemd.user.sessionVariables = { QT_QPA_PLATFORMTHEME = "kde"; };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Art P.";
      user.email = "fn3x@yandex.ru";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
    signing = {
      signByDefault = true;
      key = "D6A5181EC8F742E0";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      floating_window_scaling_factor = 0.9;
      git = {
        overrideGpg = true;
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

  nix.settings.trusted-users = [ "fn3x" ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "${config.home.homeDirectory}/nixos";
  };

  xdg.desktopEntries."org.kde.systemsettings" = {
    name = "System Settings";
    comment = "KDE Control Center";
    icon = "systemsettings";
    exec = "${pkgs.kdePackages.systemsettings} %i";
    categories = [ "Qt" "KDE" "Settings" "DesktopSettings" ];
    terminal = false;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "breeze";
    };

    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze";
    };
  };

  home.pointerCursor = {
    hyprcursor = {
      enable = true;
      size = 34;
    };
    package = inputs.mcmojave-hyprcursor.packages.x86_64-linux.default;
    name = "McMojave";
  };

  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs pkgs.obs-studio-plugins.obs-backgroundremoval pkgs.obs-studio-plugins.obs-pipewire-audio-capture ];
  };

  programs.ncspot = {
    enable = true;
    package = (pkgs.ncspot.override {
      withNotify = false;
      withPulseAudio = true;
    });
    settings = {
      backend = "pulseaudio";
      initial_screen = "library";
      use_nerdfont = true;
      theme = {
        background = "default";
        primary = "foreground";
        secondary = "light black";
        title = "primary";
        playing = "primary";
        playing_selected = "primary";
        playing_bg = "primary";
        highlight = "#FFFFFF";
        highlight_bg = "#484848";
        error = "#FF0000";
        error_bg = "red";
        statusbar = "primary";
        statusbar_progress = "primary";
        statusbar_bg = "primary";
        cmdline = "default";
        cmdline_bg = "primary";
        search_match = "light red";
      };
      keybindings = {
        "Space" = "playpause";
        "Ctrl+s" = "focus search";
        "Ctrl+l" = "focus library";
        "Ctrl+f" = "focus cover";
        "Ctrl+u" = "move pageup 1";
        "Ctrl+d" = "move pagedown 1";
        "y" = "share selected";
      };
    };
  };

  programs.cava = {
    enable = true;
    settings = {
      general.framerate = 170;
    };
  };
  
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
