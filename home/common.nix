# Home Manager settings shared by every host.
{
  pkgs,
  ...
}:
let
  username = "fn3x";
in
{
  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = "/home/${username}";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    oh-my-posh
    telegram-desktop
    fd
    ripgrep
    tmux
    vlc
    jq
    tldr
    zip
    p7zip
    dbeaver-bin
    mysql_jdbc
    openssl
    grim
    slurp
    satty
    inkscape
    libreoffice
    teamspeak6-client
    qbittorrent
    playerctl
    vesktop
    caligula
    postman
    crosspipe
    spotify
    pinta
    cava
    mariadb.client
    kdePackages.breeze-icons
    kdePackages.breeze
    kdePackages.qt6ct
    nwg-displays
    normcap
  ];

  home.file.".cache/nvim/lazygit-theme".text = "";

  xdg.mimeApps = {
    enable = true;
    defaultApplications."inode/directory" = [ "org.kde.dolphin.desktop" ];
  };

  programs.gpg.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      vim_keys = true;
      update_ms = 100;
    };
  };

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
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };

  # Fix for KDE settings for Plasma 6: https://github.com/nix-community/home-manager/issues/5098#issuecomment-2352172073
  xdg.configFile."menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
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
  systemd.user.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "";
  };

  xdg.desktopEntries."org.kde.systemsettings" = {
    name = "System Settings";
    comment = "KDE Control Center";
    icon = "systemsettings";
    exec = "${pkgs.kdePackages.systemsettings}/bin/systemsettings %i";
    categories = [
      "Qt"
      "KDE"
      "Settings"
      "DesktopSettings"
    ];
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
