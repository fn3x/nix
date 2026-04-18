{
  config,
  pkgs,
  ...
}:

let
  username = "fn3x";
  homeDirectory = "/home/${username}";
  teamspeak = import ../../modules/programs/teamspeak/teamspeak-client.nix { inherit pkgs; };
in

{
  programs.home-manager = {
    enable = true;
  };

  imports = [
    ../../home/neovim
    ../../home/ghostty
    ../../home/hypr
    ../../home/wofi
    ../../home/vicinae
    ../../home/shell
    ../../home/browsers
    ../../home/sneemok
    ../../home/caelestia
    ../../home/noctalia
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
    nerd-fonts.code-new-roman
    inkscape
    libreoffice-still
    teamspeak
    qbittorrent
    playerctl
    anydesk
    vesktop
    caligula
    postman
    wl-clipboard
    satty
    grim
    slurp
    crosspipe
    spotify
    pinta
    cava
    mariadb.client
    bash
    kdePackages.breeze-icons
    kdePackages.breeze
    kdePackages.qt6ct
    nwg-displays
    normcap
    satty
    cpupower-gui
  ];

  neovim.enable = true;
  hyprland.enable = true;
  vicinae.enable = true;
  ghostty.enable = true;
  fish.enable = true;
  brave.enable = true;
  noctalia.enable = true;

  home.file = {
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
  systemd.user.sessionVariables = { QT_QPA_PLATFORMTHEME = ""; };

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
      key = "90A7A8FC899EEB88";
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
}
