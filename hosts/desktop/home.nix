{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) concatStringsSep escapeShellArg mapAttrsToList;
  env = {
    MOZ_WEBRENDER = 1;
    # For a better scrolling implementation and touch support.
    # Be sure to also disable "Use smooth scrolling" in about:preferences
    MOZ_USE_XINPUT2 = 1;
    # Required for hardware video decoding.
    # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
    MOZ_DISABLE_RDD_SANDBOX = 1;
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
  envStr = concatStringsSep " " (mapAttrsToList (n: v: "${n}=${escapeShellArg v}") env);

  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "116.1";
    hash = "sha256-Ai8Szbrk/4FhGhS4r5gA2DqjALFRfQKo2a/TwWCIA6g=";
  };
in

{
  programs.home-manager = {
    enable = true;
  };

  home.username = "fn3x";
  home.homeDirectory = "/home/fn3x";

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
    inputs.hyprland-qtutils.packages.x86_64-linux.default
    inputs.ghostty.packages.x86_64-linux.default
    oh-my-posh
    telegram-desktop
    vesktop
    mattermost-desktop
    spotify
    fd
    ripgrep
    tmux
    vlc
    btop
    gimp
    flameshot
    lazygit
    jq
    tldr
    zip
  ];

  home.file = {
    ".config/ghostty/config" = {
      text = ''
        font-family="TX-02"
        font-size=20
        theme="Apple System Colors"
        cursor-style=block
        cursor-style-blink=true
        cursor-opacity=1
        cursor-invert-fg-bg=true
        background-blur-radius=20
        background-opacity=0.95
        title=""
        window-save-state=always
        window-decoration=false
        auto-update=check
      '';
      executable = false;
    };
  };

  services.flameshot = {
    enable = true;
    settings.General = {
      showStartupLaunchMessage = false;
      saveLastRegion = true;
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.overrideAttrs (old: {
      buildCommand =
        old.buildCommand
        + ''
          substituteInPlace $out/bin/firefox \
            --replace "exec -a" ${escapeShellArg envStr}" exec -a"
        '';
    });

    profiles.default = {
      id = 0;
      isDefault = true;

      # Hide tab bar because we have tree style tabs
      userChrome = ''
        #titlebar-buttonbox {
          height: 32px !important;
        }
      '';

      extraConfig = builtins.concatStringsSep "\n" [
        (builtins.readFile "${betterfox}/Securefox.js")
        (builtins.readFile "${betterfox}/Fastfox.js")
        (builtins.readFile "${betterfox}/Peskyfox.js")
        (builtins.readFile "${betterfox}/Smoothfox.js")
      ];

      settings = {
        "ui.key.menuAccessKeyFocuses" = false;
        # General
        "intl.accept_languages" = "en-US,en";
        "browser.startup.page" = 3; # Resume previous session on startup
        "browser.aboutConfig.showWarning" = false; # I sometimes know what I'm doing
        "browser.ctrlTab.sortByRecentlyUsed" = false; # (default) Who wants that?
        "browser.download.useDownloadDir" = false; # Ask where to save stuff
        "browser.translations.neverTranslateLanguages" = "ru"; # No need :)
        "privacy.clearOnShutdown.history" = false; # We want to save history on exit
        # Hi-DPI
        "layout.css.devPixelsPerPx" = "1.25";
        # Allow executing JS in the dev console
        "devtools.chrome.enabled" = true;
        # Disable browser crash reporting
        "browser.tabs.crashReporting.sendReport" = false;
        # Allow userCrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Why the fuck can my search window make bell sounds
        "accessibility.typeaheadfind.enablesound" = false;
        # Why the fuck can my search window make bell sounds
        "general.autoScroll" = true;

        # Hardware acceleration
        # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "media.av1.enabled" = false; # XXX: change once I've upgraded my GPU
        # XXX: what is this?
        "media.ffvpx.enabled" = false;
        "media.rdd-vpx.enabled" = false;

        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        "browser.send_pings" = false; # (default) Don't respect <a ping=...>

        # This allows firefox devs changing options for a small amount of users to test out stuff.
        # Not with me please ...
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        "beacon.enabled" = false; # No bluetooth location BS in my webbrowser please
        "device.sensors.enabled" = false; # This isn't a phone
        "geo.enabled" = false; # Disable geolocation alltogether

        # ESNI is deprecated ECH is recommended
        "network.dns.echconfig.enabled" = true;

        # Disable telemetry for privacy reasons
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false; # enforced by nixos
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.unified" = false;
        "extensions.webcompat-reporter.enabled" = false; # don't report compability problems to mozilla
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.urlbar.eventTelemetry.enabled" = false; # (default)

        # Disable some useless stuff
        "extensions.pocket.enabled" = false; # disable pocket, save links, send tabs
        "extensions.abuseReport.enabled" = false; # don't show 'report abuse' in extensions
        "extensions.formautofill.creditCards.enabled" = false; # don't auto-fill credit card information
        "identity.fxaccounts.enabled" = false; # disable firefox login
        "identity.fxaccounts.toolbar.enabled" = false;
        "identity.fxaccounts.pairing.enabled" = false;
        "identity.fxaccounts.commands.enabled" = false;
        "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manger
        "browser.uitour.enabled" = false; # no tutorial please
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # disable EME encrypted media extension (Providers can get DRM
        # through this if they include a decryption black-box program)
        "browser.eme.ui.enabled" = false;
        "media.eme.enabled" = false;

        # don't predict network requests
        "network.predictor.enabled" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;

        # disable annoying web features
        "dom.push.enabled" = false; # no notifications, really...
        "dom.push.connection.enabled" = false;
        "dom.battery.enabled" = false; # you don't need to see my battery...
        "dom.private-attribution.submission.enabled" = false; # No PPA for me pls
      };

      search = {
        force = true;
        default = "DuckDuckGo";
        order = [
          "DuckDuckGo"
          "Google"
          "GitHub"
          "Youtube"
        ];

        engines = {
          "Bing".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;
          "Google".metaData.hidden = true;

          "YouTube" = {
            iconUpdateURL = "https://youtube.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@yt" ];
            urls = [
              {
                template = "https://www.youtube.com/results";
                params = [
                  {
                    name = "search_query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

          "Google" = {
            iconUpdateURL = "https://google.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@g" ];

            urls = [
              {
                template = "https://google.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

          "DuckDuckGo" = {
            iconUpdateURL = "https://duckduckgo.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@dd" ];

            urls = [
              {
                template = "https://duckduckgo.com";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };

          "GitHub" = {
            iconUpdateURL = "https://github.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@gh" ];

            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
        };
      };

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        seventv
      ];
    };
    profiles.empty = {
      id = 1;
      isDefault = false;
    };
    profiles.onlybetterfox = {
      id = 2;
      isDefault = false;

      extraConfig = builtins.concatStringsSep "\n" [
        (builtins.readFile "${betterfox}/Securefox.js")
        (builtins.readFile "${betterfox}/Fastfox.js")
        (builtins.readFile "${betterfox}/Peskyfox.js")
      ];
    };
    profiles.onlysettings = {
      id = 3;
      isDefault = false;

      settings = {
        # General
        "intl.accept_languages" = "en-US,en";
        "browser.startup.page" = 3; # Resume previous session on startup
        "browser.ctrlTab.sortByRecentlyUsed" = false; # (default) Who wants that?
        "browser.download.useDownloadDir" = false; # Ask where to save stuff
        "browser.translations.neverTranslateLanguages" = "ru"; # No need :)
        "privacy.clearOnShutdown.history" = false; # We want to save history on exit
        # Hi-DPI
        "layout.css.devPixelsPerPx" = "1.25";
        # Allow executing JS in the dev console
        "devtools.chrome.enabled" = true;
        # Disable browser crash reporting
        "browser.tabs.crashReporting.sendReport" = false;
        # Why the fuck can my search window make bell sounds
        "accessibility.typeaheadfind.enablesound" = false;
        # Why the fuck can my search window make bell sounds
        "general.autoScroll" = true;

        # Hardware acceleration
        # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "media.av1.enabled" = false; # XXX: change once I've upgraded my GPU
        # XXX: what is this?
        "media.ffvpx.enabled" = false;
        "media.rdd-vpx.enabled" = false;

        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        "browser.send_pings" = false; # (default) Don't respect <a ping=...>

        # This allows firefox devs changing options for a small amount of users to test out stuff.
        # Not with me please ...
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        "beacon.enabled" = false; # No bluetooth location BS in my webbrowser please
        "device.sensors.enabled" = false; # This isn't a phone
        "geo.enabled" = false; # Disable geolocation alltogether

        # ESNI is deprecated ECH is recommended
        "network.dns.echconfig.enabled" = true;

        # Disable telemetry for privacy reasons
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false; # enforced by nixos
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.unified" = false;
        "extensions.webcompat-reporter.enabled" = false; # don't report compability problems to mozilla
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.urlbar.eventTelemetry.enabled" = false; # (default)

        # Disable some useless stuff
        "extensions.pocket.enabled" = false; # disable pocket, save links, send tabs
        "extensions.abuseReport.enabled" = false; # don't show 'report abuse' in extensions
        "extensions.formautofill.creditCards.enabled" = false; # don't auto-fill credit card information
        "identity.fxaccounts.enabled" = false; # disable firefox login
        "identity.fxaccounts.toolbar.enabled" = false;
        "identity.fxaccounts.pairing.enabled" = false;
        "identity.fxaccounts.commands.enabled" = false;
        "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manger
        "browser.uitour.enabled" = false; # no tutorial please
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # disable EME encrypted media extension (Providers can get DRM
        # through this if they include a decryption black-box program)
        "browser.eme.ui.enabled" = false;
        "media.eme.enabled" = false;

        # don't predict network requests
        "network.predictor.enabled" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;

        # disable annoying web features
        "dom.push.enabled" = false; # no notifications, really...
        "dom.push.connection.enabled" = false;
        "dom.battery.enabled" = false; # you don't need to see my battery...
        "dom.private-attribution.submission.enabled" = false; # No PPA for me pls
      };
    };
    profiles.same = {
      id = 4;
      isDefault = false;

      extraConfig = builtins.concatStringsSep "\n" [
        (builtins.readFile "${betterfox}/Securefox.js")
        (builtins.readFile "${betterfox}/Fastfox.js")
        (builtins.readFile "${betterfox}/Peskyfox.js")
      ];

      settings = {
        # General
        "intl.accept_languages" = "en-US,en";
        "browser.startup.page" = 3; # Resume previous session on startup
        "browser.ctrlTab.sortByRecentlyUsed" = false; # (default) Who wants that?
        "browser.download.useDownloadDir" = false; # Ask where to save stuff
        "browser.translations.neverTranslateLanguages" = "ru"; # No need :)
        "privacy.clearOnShutdown.history" = false; # We want to save history on exit
        # Hi-DPI
        "layout.css.devPixelsPerPx" = "1.25";
        # Allow executing JS in the dev console
        "devtools.chrome.enabled" = true;
        # Disable browser crash reporting
        "browser.tabs.crashReporting.sendReport" = false;
        # Why the fuck can my search window make bell sounds
        "accessibility.typeaheadfind.enablesound" = false;
        # Why the fuck can my search window make bell sounds
        "general.autoScroll" = true;

        # Hardware acceleration
        # See https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "media.av1.enabled" = false; # XXX: change once I've upgraded my GPU
        # XXX: what is this?
        "media.ffvpx.enabled" = false;
        "media.rdd-vpx.enabled" = false;

        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        "browser.send_pings" = false; # (default) Don't respect <a ping=...>

        # This allows firefox devs changing options for a small amount of users to test out stuff.
        # Not with me please ...
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        "beacon.enabled" = false; # No bluetooth location BS in my webbrowser please
        "device.sensors.enabled" = false; # This isn't a phone
        "geo.enabled" = false; # Disable geolocation alltogether

        # ESNI is deprecated ECH is recommended
        "network.dns.echconfig.enabled" = true;

        # Disable telemetry for privacy reasons
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false; # enforced by nixos
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.unified" = false;
        "extensions.webcompat-reporter.enabled" = false; # don't report compability problems to mozilla
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.urlbar.eventTelemetry.enabled" = false; # (default)

        # Disable some useless stuff
        "extensions.pocket.enabled" = false; # disable pocket, save links, send tabs
        "extensions.abuseReport.enabled" = false; # don't show 'report abuse' in extensions
        "extensions.formautofill.creditCards.enabled" = false; # don't auto-fill credit card information
        "identity.fxaccounts.enabled" = false; # disable firefox login
        "identity.fxaccounts.toolbar.enabled" = false;
        "identity.fxaccounts.pairing.enabled" = false;
        "identity.fxaccounts.commands.enabled" = false;
        "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manger
        "browser.uitour.enabled" = false; # no tutorial please
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # disable EME encrypted media extension (Providers can get DRM
        # through this if they include a decryption black-box program)
        "browser.eme.ui.enabled" = false;
        "media.eme.enabled" = false;

        # don't predict network requests
        "network.predictor.enabled" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;

        # disable annoying web features
        "dom.push.enabled" = false; # no notifications, really...
        "dom.push.connection.enabled" = false;
        "dom.battery.enabled" = false; # you don't need to see my battery...
        "dom.private-attribution.submission.enabled" = false; # No PPA for me pls
      };
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      vim_keys = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
  };

  home.shellAliases = {
    nix-s = "nh os switch ~/nixos/";
    nix-t = "nh os test ~/nixos/";
    nix-c = "nh clean all";
    nix-u = "nh os test -u";
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
    LD_LIBRARY_PATH = "~/local/lib:$LD_LIBRARY_PATH";
    MANPATH = "~/local/share/man:$MANPATH";
    COLORTERM = "truecolor";
    NVM_DIR = "~/.nvm";
  };

  programs.kitty.enable = true; # required for the default Hyprland config

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "ALT";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun -show-icons";
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bind =
        [
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          "$mod, T, exec, $terminal"
          "$mod SHIFT, Q, killactive"
          "$mod, M, exit"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating"
          "$mod, P, pseudo, # dwindle"
          "$mod, J, togglesplit, # dwindle"
          "$mod, SPACE, exec, $menu"
          "$mod SHIFT, S, exec, XDG_CURRENT_DESKTOP=sway flameshot gui"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
    };
    extraConfig = ''
      ################
      ### MONITORS ###
      ################

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = DP-1, 2560x1440@170.00Hz, 0x0, 1

      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      # See https://wiki.hyprland.org/Configuring/Environment-variables/

      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24
      env = GBM_BACKEND,nvidia-drm
      env = LIBVA_DRIVER_NAME,nvidia
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = GDK_BACKEND,wayland,x11,*
      env = QT_QPA_PLATFORM,wayland;xcb
      env = SDL_VIDEODRIVER,wayland
      env = CLUTTER_BACKEND,wayland
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = GTK_THEME,Arc-Dark

      #################
      ### AUTOSTART ###
      #################

      # from hyprland wiki - should speed up launches of apps
      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once=systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      exec-once = dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'"
      exec-once = dconf write /org/gnome/desktop/interface/icon-theme "'Flat-Remix-Red-Dark'"
      exec-once = dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans Medium 11'"
      exec-once = dconf write /org/gnome/desktop/interface/font-name "'Noto Sans Medium 11'"
      exec-once = dconf write /org/gnome/desktop/interface/monospace-font-name "'Noto Sans Mono Medium 11'"
      exec-once = swww init
      exec-once = waybar
      exec-once = dunst
      exec-once = [workspace 1 silent] $terminal
      exec-once = [workspace 2 silent] firefox
      exec-once = [workspace 3 silent] telegram-desktop
      exec-once = [workspace 4 silent] mattermost-desktop
      exec-once = [workspace 5 silent] spotify

      #####################
      ### LOOK AND FEEL ###
      #####################

      # https://wiki.hyprland.org/Configuring/Variables/#general

      general {
          gaps_in = 10
          gaps_out = 5

          border_size = 1

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = dwindle
      }

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration {
          rounding = 10

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0
          inactive_opacity = 1.0

          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur {
              enabled = true
              size = 3
              passes = 1

              vibrancy = 0.1696
          }
      }

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations {
          enabled = yes, please :)

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1

          animation = global, 1, 10, default
          animation = border, 1, 2.5, easeOutQuint
          animation = windows, 1, 2.5, easeOutQuint
          animation = windowsIn, 1, 2.0, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.25, linear, popin 87%
          animation = fadeIn, 1, 1.5, almostLinear
          animation = fadeOut, 1, 1.2, almostLinear
          animation = fade, 1, 2.0, quick
          animation = layers, 1, 2.0, easeOutQuint
          animation = layersIn, 1, 2.0, easeOutQuint, fade
          animation = layersOut, 1, 1.25, linear, fade
          animation = fadeLayersIn, 1, 1.4, almostLinear
          animation = fadeLayersOut, 1, 1.2, almostLinear
          animation = workspaces, 1, 1.5, almostLinear, fade
          animation = workspacesIn, 1, 1.1, almostLinear, fade
          animation = workspacesOut, 1, 1.5, almostLinear, fade
      }

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc {
          force_default_wallpaper = 1
          disable_hyprland_logo = true
      }

      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input {
          kb_layout = us,ru
          kb_variant =
          kb_model = kinesis
          kb_options = grp:win_space_toggle
          kb_rules =

          follow_mouse = 1

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
          repeat_delay = 300
          repeat_rate = 50
      }

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures {
          workspace_swipe = false
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      # Ignore maximize requests from apps. You'll probably like this.
      windowrulev2 = suppressevent maximize decorate:0, class:.*

      # Fix some dragging issues with XWayland
      windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

      # windowrulev2 = tile,maximize,workspace 1,class:com.mitchellh.ghostty,initialClass:(- com.mitchellh.ghostty)
      # windowrulev2 = tile,maximize,workspace 2,class:firefox,initialClass:(- firefox)
      # windowrulev2 = tile,maximize,workspace 3,class:org.telegram.desktop,initialClass:(- org.telegram.desktop)
      # windowrulev2 = tile,maximize,workspace 4,class:Mattermost,initialClass:(- Mattermost)
      # windowrulev2 = tile,maximize,workspace 5,class:spotify,initialClass:(- spotify)

      # Fixes for flameshot on wayland
      windowrulev2 = float, class:^(flameshot)$
      windowrulev2 = move 0 0, class:^(flameshot)$
      windowrulev2 = pin, class:^(flameshot)$
      # set this to your leftmost monitor id, otherwise you have to move your cursor to the leftmost monitor
      # before executing flameshot
      windowrulev2 = monitor 1, class:^(flameshot)$
    '';
  };

  programs.git = {
    enable = true;
    userName = "Art P.";
    userEmail = "fn3x@yandex.com";
    signing = {
      signByDefault = false;
      key = null;
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      floating_window_scaling_factor = 0.9;
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    disableConfirmationPrompt = true;
    sensibleOnTop = true;
    terminal = "screen-256color";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-dir '~/.tmux/resurrect'
        '';
      }
    ];
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      set-option -g mouse on

      ## change mouse drag to be adequate
      unbind -Tcopy-mode MouseDragEnd1Pane

      setw -g pane-base-index 1

      bind p previous-window
      bind n next-window

      ## change the key to enter copy mode from `[` to `a`
      unbind [
      bind a copy-mode

      ## set keys for visual mode (v) and yank/copy (y)
      bind-key -Tcopy-mode-vi 'v' send -X begin-selection
      bind-key -Tcopy-mode-vi 'y' send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      set -g history-limit 10000

      bind j select-window -t 1
      bind k select-window -t 2
      bind "l" select-window -t 3
      bind ";" select-window -t 4

      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # clock mode
      setw -g clock-mode-colour colour220

      # statusbar
      set -g status-justify left
      set -g status-style 'fg=colour220'
      set -g status-left '#{session_name} -> '
      set -g status-right '%Y-%m-%d %H:%M'
      set -g status-right-length 200
      set -g status-left-length 10
      setw -g window-status-current-style 'fg=colour0 bg=colour220 bold'
      setw -g window-status-current-format ' #I #W #F '
      setw -g window-status-style 'fg=colour220 dim'
      setw -g window-status-format ' #I #[fg=colour7]#W #[fg=colour220]#F '
      setw -g window-status-bell-style 'fg=colour2 bg=colour220 bold'

      # messages
      set -g message-style 'fg=colour2 bg=colour0 bold'
      # copy mode
      setw -g mode-style 'fg=colour178 bg=colour235 bold'
      set -g renumber-windows on       # renumber all windows when any window is closed
      set -g set-clipboard on          # use system clipboard
      set -g status-position top       # macOS / darwin style
      set -g default-terminal "tmux-256color"
      set-option -sa terminal-features ",xterm-256color:RGB"
      setw -g mode-keys vi
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'

      # create new windows in the current path
      bind '"' split-window -c '#{pane_current_path}'
      bind % split-window -hc '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'

      # mouse wheel
      bind -n WheelUpPane if -Ft= "#{mouse_any_flag}" "send -M" "send Up"
      bind -n WheelDownPane if -Ft= "#{mouse_any_flag}" "send -M" "send Down"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "robbyrussell";
  };

  nix.settings.trusted-users = [ "fn3x" ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "${config.home.homeDirectory}/nixos";
  };

  programs.nixvim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.x86_64-linux.neovim;

    clipboard.providers.wl-copy.enable = true;

    opts = {
      clipboard = "unnamedplus";

      number = true;
      relativenumber = true;

      autoindent = true;
      cindent = true;
      wrap = false;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      breakindent = true;
      updatetime = 100;

      guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,i:blinkwait500-blinkoff400-blinkon500-Cursor/lCursor";
      mouse = "";
      undofile = true;
      undodir = "${config.home.homeDirectory}/.undodir";
      hlsearch = false;
      incsearch = true;
      ignorecase = false;
      smartcase = true;

      scrolloff = 8;
      signcolumn = "yes";
      colorcolumn = "120";

      splitright = true;

      wildmenu = false;
      wildmode = "";

      fileencoding = "utf-8";
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";

      pumheight = 5;
      disable_autoformat = true;
      loaded_node_provider = 0;

      gruvbox_material_background = "medium";
      gruvbox_material_better_performance = 1;
      gruvbox_material_enable_bold = 0;
      gruvbox_material_menu_selection_background = "aqua";
      gruvbox_material_visual = "blue background";
      gruvbox_material_foreground = "material";
      gruvbox_material_float_style = "bright";
      gruvbox_material_diagnostic_virtual_text = "colored";
    };

    colorscheme = "gruvbox-material";

    keymaps = [
      {
        mode = "n";
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Open parent directory";
        };
      }
      # Filetree
      {
        mode = "n";
        key = "<leader>fp";
        action = "<cmd>Oil<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Open parent directory";
        };
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Remove highlights of the last search";
        };
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options = {
          noremap = true;
          silent = true;
          desc = "Move line up by 1 line and format it";
        };
      }
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options = {
          noremap = true;
          silent = true;
          desc = "Move line down by 1 line and format it";
        };
      }

      # Movement
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
        options = {
          noremap = true;
          silent = true;
          desc = "Scroll down and center";
        };
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
        options = {
          noremap = true;
          silent = true;
          desc = "Scroll up and center";
        };
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
        options = {
          noremap = true;
          silent = true;
          desc = "Next occurence and center";
        };
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options = {
          noremap = true;
          silent = true;
          desc = "Previous occurence and center";
        };
      }
      {
        mode = "x";
        key = "<leader>p";
        action = ''"_dP'';
        options = {
          noremap = true;
          silent = true;
          desc = "Replace without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader>d";
        action = ''"_d'';
        options = {
          noremap = true;
          silent = true;
          desc = "Delete without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader>D";
        action = ''"_D'';
        options = {
          noremap = true;
          silent = true;
          desc = "Delete until EOL without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader>c";
        action = ''"_c'';
        options = {
          noremap = true;
          silent = true;
          desc = "Change without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader>C";
        action = ''"_C'';
        options = {
          noremap = true;
          silent = true;
          desc = "Change until EOL without yanking";
        };
      }
      {
        mode = "n";
        key = "<leader><leader>";
        action = "<cmd>:w<CR>";
        options = {
          noremap = true;
          silent = true;
          desc = "Save current buffer";
        };
      }
      # Snacks keymaps
      {
        mode = "n";
        key = "<leader>n";
        action.__raw = "function() Snacks.notifier.show_history() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Notification History";
        };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action.__raw = "function() Snacks.git.blame_line() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Git Blame Line";
        };
      }
      {
        mode = "n";
        key = "<leader>gf";
        action.__raw = "function() Snacks.lazygit.log_file() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Lazygit Current File History";
        };
      }
      {
        mode = "n";
        key = "<leader>gg";
        action.__raw = "function() Snacks.lazygit() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Lazygit";
        };
      }
      {
        mode = "n";
        key = "<leader>gl";
        action.__raw = "function() Snacks.lazygit.log() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Lazygit Log (cwd)";
        };
      }
      {
        mode = "n";
        key = "<leader>un";
        action.__raw = "function() Snacks.notifier.hide() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Dismiss All Notifications";
        };
      }
      {
        mode = "n";
        key = "<leader>a";
        action.__raw = "function() require('harpoon'):list():add() end";
        options = {
          noremap = true;
          silent = true;
          desc = "Add file to harpoon list";
        };
      }
      {
        mode = "n";
        key = "<C-e>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon.ui:toggle_quick_menu(harpoon:list()) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Toggle quick menu";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon:list():select(1) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Select first item from the list";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon:list():select(2) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Select second item from the list";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon:list():select(3) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Select third item from the list";
        };
      }
      {
        mode = "n";
        key = "<C-;>";
        action.__raw = "function() local harpoon = require('harpoon'); harpoon:list():select(4) end";
        options = {
          noremap = true;
          silent = true;
          desc = "Select fourth item from the list";
        };
      }
    ];

    autoGroups = {
      HighlightYank = {
        clear = true;
      };
    };

    autoCmd = [
      {
        event = "TextYankPost";
        group = "HighlightYank";
        pattern = "*";
        callback = {
          __raw = ''function()vim.highlight.on_yank({higroup = "IncSearch",timeout = 40,}) end'';
        };
      }
      {
        event = "User";
        pattern = "VeryLazy";
        callback = {
          __raw = ''
            function()
              -- Setup some globals for debugging (lazy-loaded)
              _G.dd = function(...)
                Snacks.debug.inspect(...);
              end
              _G.bt = function()
                Snacks.debug.backtrace();
              end
              vim.print = _G.dd -- Override print to use snacks for `:=` command

              -- Create some toggle mappings
              Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw");
              Snacks.toggle.diagnostics():map("<leader>ud");
            end
          '';
        };
      }
      {
        event = "BufWritePre";
        pattern = "*";
        callback.__raw = ''
          function(args)
            local bufnr = args.buf

            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if string.match(bufname, "/node_modules/") then
              return
            end

            require("conform").format({
              bufnr = bufnr,
              timeout_ms = 500,
              lsp_fallback = true,
              async = false,
            })
          end
        '';
      }
    ];

    plugins = {
      harpoon = {
        enable = true;
        package = pkgs.vimPlugins.harpoon2;
        saveOnToggle = true;
        saveOnChange = true;
        # These keymaps are for harpoon1, not harpoon2
        # Keymaps for harpoon2 are in nixvim.keymaps
        #
        # keymaps = {
        #   addFile = "<leader>a";
        #   toggleQuickMenu = "<C-e>";
        #   navFile = {
        #     "1" = "<C-j>";
        #     "2" = "<C-k>";
        #     "3" = "<C-l>";
        #     "4" = "<C-;>";
        #   };
        #   navNext = "<C-S-n>";
        #   navPrev = "<C-S-p>";
        # };
      };

      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          delete_to_trash = true;
          skip_confirm_for_simple_edits = true;
          buf_options = {
            bufhidden = "hide";
            buflisted = false;
          };
          view_options = {
            show_hidden = true;
          };
        };
      };

      lualine = {
        enable = true;
        autoLoad = true;
        settings = {
          extensions = [ "fzf" ];
        };
      };

      web-devicons = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      undotree = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      sandwich = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      dressing = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      comment = {
        enable = true;
        settings = {
          lazyLoad = true;
        };
      };

      refactoring = {
        enable = true;
        settings = {
          lazyLoad = false;
        };
      };

      snacks = {
        enable = true;
        settings = {
          bigfile = {
            enabled = true;
            size = 1.5 * 1024 * 1024;
            notify = true;
          };
          notifier = {
            enabled = true;
            timeout = 2000;
          };
          quickfile = {
            enabled = true;
          };
          styles = {
            notification = {
              wo = {
                wrap = true;
              };
            };
          };
        };
      };

      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "javascript"
            "typescript"
            "lua"
            "go"
            "zig"
            "html"
          ];
          auto_install = true;
          sync_install = false;
          highlight = {
            additional_vim_regex_highlighting = false;
            custom_captures = { };
            disable = [ ];
            enable = true;
          };
          ignore_install = [ ];
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = false;
              node_decremental = "grm";
              node_incremental = "grn";
              scope_incremental = "grc";
            };
          };
          indent = {
            enable = true;
          };
          parser_install_dir = {
            __raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'treesitter')";
          };
        };
      };

      treesitter-context = {
        settings = {
          enable = true;
        };
      };

      treesitter-textobjects = {
        enable = true;
        move = {
          enable = true;
          setJumps = true;
          gotoNextStart = {
            "]m" = "@function.outer";
            "gj" = "@function.outer";
            "]]" = "@class.outer";
            "]b" = "@block.outer";
            "]a" = "@parameter.inner";
          };
          gotoNextEnd = {
            "]M" = "@function.outer";
            "gJ" = "@function.outer";
            "][" = "@class.outer";
            "]B" = "@block.outer";
            "]A" = "@parameter.inner";
          };
          gotoPreviousStart = {
            "[m" = "@function.outer";
            "gk" = "@function.outer";
            "[[" = "@class.outer";
            "[b" = "@block.outer";
            "[a" = "@parameter.inner";
          };
          gotoPreviousEnd = {
            "[M" = "@function.outer";
            "gK" = "@function.outer";
            "[]" = "@class.outer";
            "[B" = "@block.outer";
            "[A" = "@parameter.inner";
          };
        };
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ab" = "@block.outer";
            "ib" = "@block.inner";
            "al" = "@loop.outer";
            "il" = "@loop.inner";
            "a/" = "@comment.outer";
            "i/" = "@comment.outer";
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
          };
        };
      };

      telescope = {
        enable = true;
        settings = {
          defaults = {
            layout_strategy = "horizontal";
          };
        };
        extensions = {
          fzf-native.enable = true;
        };
        keymaps = {
          "<leader>fb" = {
            action = "buffers";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<leader>ps" = {
            action = "live_grep";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<leader>fz" = {
            action = "find_files";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<C-s>" = {
            action = "grep_string";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<leader>fd" = {
            action = "diagnostics";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
          "<leader>;" = {
            action = "resume";
            mode = "n";
            options = {
              noremap = true;
              silent = true;
            };
          };
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          on_attach.__raw = ''
              function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- Navigation
              map("n", "]c", function()
                if vim.wo.diff then
                  return "]c"
                end
                vim.schedule(function()
                  gs.next_hunk()
                end)
                return "<Ignore>"
              end, { expr = true })

              map("n", "[c", function()
                if vim.wo.diff then
                  return "[c"
                end
                vim.schedule(function()
                  gs.prev_hunk()
                end)
                return "<Ignore>"
              end, { expr = true })

              -- Actions
              map("n", "<leader>hs", gs.stage_hunk)
              map("n", "<leader>hr", gs.reset_hunk)
              map("v", "<leader>hs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end)
              map("v", "<leader>hr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end)
              map("n", "<leader>hS", gs.stage_buffer)
              map("n", "<leader>hu", gs.undo_stage_hunk)
              map("n", "<leader>hR", gs.reset_buffer)
              map("n", "<leader>hp", gs.preview_hunk)
              map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
              end)
              map("n", "<leader>tb", gs.toggle_current_line_blame)
              map("n", "<leader>hd", gs.diffthis)
              map("n", "<leader>hD", function()
                gs.diffthis("~")
              end)
              map("n", "<leader>td", gs.toggle_deleted)

              -- Text object
              map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end
          '';
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = true;
          default_format_opts = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
          formatters_by_ft = {
            lua = [ "stylua" ];
            go = [ "gofumpt" ];
            sql = [ "sql-formatter" ];
            javascript = [
              "prettierd"
              "prettier"
            ];
            html = [
              "prettierd"
              "prettier"
            ];
            typescript = [
              "prettierd"
              "prettier"
            ];
            nix = [ "nixfmt-rfc-style" ];
          };
          formatters = {
            stylua = {
              command = lib.getExe pkgs.stylua;
            };
            prettierd = {
              command = lib.getExe pkgs.prettierd;
            };
            prettier = {
              command = lib.getExe pkgs.nodePackages_latest.prettier;
            };
            gofumpt = {
              command = lib.getExe pkgs.gofumpt;
            };
            nixfmt-rfc-style = {
              command = lib.getExe pkgs.nixfmt-rfc-style;
            };
          };
        };
      };

      luasnip = {
        enable = true;
        fromVscode = [
          {
            lazyLoad = true;
            paths = "${pkgs.vimPlugins.friendly-snippets}";
          }
        ];
      };

      cmp-buffer = {
        enable = true;
      };

      cmp-path = {
        enable = true;
      };

      cmp-nvim-lsp = {
        enable = true;
      };

      cmp-nvim-lsp-signature-help = {
        enable = true;
      };

      cmp_luasnip = {
        enable = true;
      };

      lspkind = {
        enable = true;
        cmp = {
          enable = true;
          ellipsisChar = "...";
          maxWidth = 50;
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          snippet.expand = ''
            function(args)
              require("luasnip").lsp_expand(args.body)
            end
          '';
          window = {
            completion.border = "rounded";
            documentation.border = "rounded";
          };
          formatting = {
            expandable_indicator = false;
          };
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-space>"] = cmp.mapping.confirm({ select = true }),
                ["<C-y>"] = cmp.mapping.complete(),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<Tab>"] = cmp.mapping(function(fallback)
                  local luasnip = require("luasnip")
                  if luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                  local luasnip = require("luasnip")
                  if luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
              })
            '';
          };
        };
      };

      lsp = {
        enable = true;
        inlayHints = true;
        capabilities = ''
          require("cmp_nvim_lsp").default_capabilities()
        '';
        keymaps = {
          silent = true;
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gi" = "implementation";
            "<leader>ca" = "code_action";
            "<leader>rf" = "references";
            "<leader>rr" = "rename";
            "K" = "hover";
            "<C-h>" = "signature_help";
          };
          extra = [
            {
              key = "[d";
              mode = "n";
              action.__raw = "function() vim.diagnostic.jump({ count = 1 }) end";
            }
            {
              key = "]d";
              mode = "n";
              action.__raw = "function() vim.diagnostic.jump({ count = -1 }) end";
            }
            {
              key = "<leader>ff";
              mode = "n";
              action.__raw = "function() vim.lsp.buf.format({ async = false, timeout_ms = 1000 }) end";
            }
          ];
        };
        servers = {
          html = {
            enable = true;
          };
          lua_ls = {
            enable = true;
          };
          nixd = {
            enable = true;
          };
          gopls = {
            enable = true;
            settings = {
              gofumpt = true;
            };
          };
          ts_ls = {
            enable = true;
            filetypes = [
              "typescript"
              "javascript"
              "typescriptreact"
              "javascriptreact"
            ];
            settings = {
              preferences = {
                quotePreference = "double";
              };
            };
          };
          tailwindcss = {
            enable = true;
            filetypes = [ "go" ];
            settings = {
              tailwindCSS = {
                includeLanguages = {
                  go = "html";
                };
                experimental = {
                  classRegex = [
                    [
                      "Class\\(([^)]*)\\)"
                      "[\"`]([^\"`]*)[\"`]"
                    ]
                    [
                      "ClassX\\(([^)]*)\\)"
                      "[\"`]([^\"`]*)[\"`]"
                    ]
                    [
                      "ClassIf\\(([^)]*)\\)"
                      "[\"`]([^\"`]*)[\"`]"
                    ]
                    [
                      "Classes\\(([^)]*)\\)"
                      "[\"`]([^\"`]*)[\"`]"
                    ]
                  ];
                };
              };
            };
          };
          ols = {
            enable = true;
          };
          zls = {
            enable = true;
          };
        };
      };
    };

    extraPlugins = [ pkgs.vimPlugins.gruvbox-material-nvim ];
    extraConfigLua = ''
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#b8fcec", bold = false });
      vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true });
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#fcd6a9", bold = false });
      ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
          if not client or type(value) ~= "table" then
            return
          end
          local p = progress[client.id]

          for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
              p[i] = {
                token = ev.data.params.token,
                msg = ("[%3d%%] %s%s"):format(
                  value.kind == "end" and 100 or value.percentage or 100,
                  value.title or "",
                  value.message and (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
              }
              break
            end
          end

          local msg = {} ---@type string[]
          progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
          end, p)

          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
              notif.icon = #progress[client.id] == 0 and " "
              or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    '';
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
