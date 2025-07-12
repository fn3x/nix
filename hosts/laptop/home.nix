{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  username = "fn3x";
  homeDirectory = "/home/${username}";
  thorium-browser = import ../../modules/nixos/thorium.nix { inherit pkgs lib; };
  nushell-theme = "${homeDirectory}/nushell/gruvbox-dark.nu";
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
    inputs.hyprland-qtutils.packages.x86_64-linux.default
    inputs.ghostty.packages.x86_64-linux.default
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
    oh-my-posh
    telegram-desktop
    mattermost-desktop
    spotify
    cantarell-fonts
    noto-fonts
    noto-fonts-emoji
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
    lutris
    thorium-browser
    teamspeak6-client
    qbittorrent
    playerctl
    anydesk
    river
    wine
    winetricks
    vesktop
    thunderbird
    r2modman
    whitesur-kde
    caligula
    postman
    redisinsight
    pcsx2
    prismlauncher
    rustdesk-flutter
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
        shell-integration=none

        keybind=ctrl+b>u=scroll_page_fractional:-0.5
        keybind=ctrl+b>d=scroll_page_fractional:0.5

        keybind=ctrl+b>ctrl+j=new_split:down
        keybind=ctrl+b>ctrl+k=new_split:up
        keybind=ctrl+b>ctrl+h=new_split:left
        keybind=ctrl+b>ctrl+l=new_split:right
        keybind=ctrl+b>c=new_split:auto

        keybind=ctrl+b>j=goto_split:down
        keybind=ctrl+b>k=goto_split:up
        keybind=ctrl+b>h=goto_split:left
        keybind=ctrl+b>l=goto_split:right
        keybind=ctrl+b>n=goto_split:next
        keybind=ctrl+b>p=goto_split:previous

        keybind=ctrl+b>f=toggle_split_zoom

        keybind=ctrl+b>t=new_tab

        keybind=ctrl+b>1=goto_tab:1
        keybind=ctrl+b>2=goto_tab:2
        keybind=ctrl+b>3=goto_tab:3
        keybind=ctrl+b>4=goto_tab:4
        keybind=ctrl+b>5=goto_tab:5
        keybind=ctrl+b>6=goto_tab:6
        keybind=ctrl+b>7=goto_tab:7
        keybind=ctrl+b>8=goto_tab:8
        keybind=ctrl+b>9=goto_tab:9

        keybind=ctrl+b>shift+j=resize_split:down,10
        keybind=ctrl+b>shift+k=resize_split:up,10
        keybind=ctrl+b>shift+h=resize_split:left,10
        keybind=ctrl+b>shift+l=resize_split:right,10

        keybind=ctrl+b>equal=equalize_splits

        keybind=ctrl+b>s=toggle_tab_overview
      '';
      executable = false;
    };
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
    "${homeDirectory}/.config/hypr/xdph.conf" = {
      text = ''
        screencopy {
          allow_token_by_default = true
        }
      '';
      executable = false;
    };
    "${nushell-theme}" = {
      text = ''
        # Retrieve the theme settings
        export def main [] {
            return {
                binary: '#b16286'
                block: '#458588'
                cell-path: '#a89984'
                closure: '#689d6a'
                custom: '#ebdbb2'
                duration: '#d79921'
                float: '#fb4934'
                glob: '#ebdbb2'
                int: '#b16286'
                list: '#689d6a'
                nothing: '#cc241d'
                range: '#d79921'
                record: '#689d6a'
                string: '#98971a'

                bool: {|| if $in { '#8ec07c' } else { '#d79921' } }

                datetime: {|| (date now) - $in |
                    if $in < 1hr {
                        { fg: '#cc241d' attr: 'b' }
                    } else if $in < 6hr {
                        '#cc241d'
                    } else if $in < 1day {
                        '#d79921'
                    } else if $in < 3day {
                        '#98971a'
                    } else if $in < 1wk {
                        { fg: '#98971a' attr: 'b' }
                    } else if $in < 6wk {
                        '#689d6a'
                    } else if $in < 52wk {
                        '#458588'
                    } else { 'dark_gray' }
                }

                filesize: {|e|
                    if $e == 0b {
                        '#a89984'
                    } else if $e < 1mb {
                        '#689d6a'
                    } else {{ fg: '#458588' }}
                }

                shape_and: { fg: '#b16286' attr: 'b' }
                shape_binary: { fg: '#b16286' attr: 'b' }
                shape_block: { fg: '#458588' attr: 'b' }
                shape_bool: '#8ec07c'
                shape_closure: { fg: '#689d6a' attr: 'b' }
                shape_custom: '#98971a'
                shape_datetime: { fg: '#689d6a' attr: 'b' }
                shape_directory: '#689d6a'
                shape_external: '#689d6a'
                shape_external_resolved: '#8ec07c'
                shape_externalarg: { fg: '#98971a' attr: 'b' }
                shape_filepath: '#689d6a'
                shape_flag: { fg: '#458588' attr: 'b' }
                shape_float: { fg: '#fb4934' attr: 'b' }
                shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
                shape_glob_interpolation: { fg: '#689d6a' attr: 'b' }
                shape_globpattern: { fg: '#689d6a' attr: 'b' }
                shape_int: { fg: '#b16286' attr: 'b' }
                shape_internalcall: { fg: '#689d6a' attr: 'b' }
                shape_keyword: { fg: '#b16286' attr: 'b' }
                shape_list: { fg: '#689d6a' attr: 'b' }
                shape_literal: '#458588'
                shape_match_pattern: '#98971a'
                shape_matching_brackets: { attr: 'u' }
                shape_nothing: '#cc241d'
                shape_operator: '#d79921'
                shape_or: { fg: '#b16286' attr: 'b' }
                shape_pipe: { fg: '#b16286' attr: 'b' }
                shape_range: { fg: '#d79921' attr: 'b' }
                shape_raw_string: { fg: '#ebdbb2' attr: 'b' }
                shape_record: { fg: '#689d6a' attr: 'b' }
                shape_redirection: { fg: '#b16286' attr: 'b' }
                shape_signature: { fg: '#98971a' attr: 'b' }
                shape_string: '#98971a'
                shape_string_interpolation: { fg: '#689d6a' attr: 'b' }
                shape_table: { fg: '#458588' attr: 'b' }
                shape_vardecl: { fg: '#458588' attr: 'u' }
                shape_variable: '#b16286'

                foreground: '#ebdbb2'
                background: '#282828'
                cursor: '#ebdbb2'

                empty: '#458588'
                header: { fg: '#98971a' attr: 'b' }
                hints: '#928374'
                leading_trailing_space_bg: { attr: 'n' }
                row_index: { fg: '#98971a' attr: 'b' }
                search_result: { fg: '#cc241d' bg: '#a89984' }
                separator: '#a89984'
            }
        }

        # Update the Nushell configuration
        export def --env "set color_config" [] {
            $env.config.color_config = (main)
        }

        # Update terminal colors
        export def "update terminal" [] {
            let theme = (main)

            # Set terminal colors
            let osc_screen_foreground_color = '10;'
            let osc_screen_background_color = '11;'
            let osc_cursor_color = '12;'
                
            $"
            (ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)
            (ansi -o $osc_screen_background_color)($theme.background)(char bel)
            (ansi -o $osc_cursor_color)($theme.cursor)(char bel)
            "
            # Line breaks above are just for source readability
            # but create extra whitespace when activating. Collapse
            # to one line and print with no-newline
            | str replace --all "\n" '''
            | print -n $"($in)\r"
        }

        export module activate {
            export-env {
                set color_config
                update terminal
            }
        }

        # Activate the theme when sourced
        use activate
      '';
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

  home.shellAliases = {
    nix-s = "nh os switch -H laptop ~/nixos";
    nix-t = "nh os test  -H laptop ~/nixos";
    nix-c = "nh clean all";
    nix-u = "nh os switch -u -H laptop ~/nixos";
    vim = "nvim";
    vi = "nvim";
    nix-work = "nix develop ~/nixos/shells#work";
    nix-zig = "nix develop ~/nixos/shells#zig";
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
    "~/go"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
    TERM = "ghostty";
    LD_LIBRARY_PATH = "~/local/lib:$LD_LIBRARY_PATH";
    MANPATH = "~/local/share/man:$MANPATH";
    COLORTERM = "truecolor";
    NVM_DIR = "~/.nvm";
    GOPATH=homeDirectory;
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
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

  wayland.windowManager.river = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      border-width = 1;
      declare-mode = [
        "locked"
        "normal"
        "passthrough"
      ];
      input = {
        pointer = {
          accel-profile = "flat";
          events = true;
          pointer-accel = 0;
          tap = false;
        };
      };
      map = {
        normal = {
          "Mod1 F" = "toggle-fullscreen";
          "Mod1 V" = "toggle-float";
          "Mod1 Space" = "wofi --show drun --define=drun-print_desktop_file=true";

          "Mod1+Shift Q" = "close";
          "Mod1 1" = "set-focused-tags 1";
          "Mod1 2" = "set-focused-tags 2";
          "Mod1 3" = "set-focused-tags 3";
          "Mod1 4" = "set-focused-tags 4";
          "Mod1 5" = "set-focused-tags 5";
          "Mod1 6" = "set-focused-tags 6";
          "Mod1 7" = "set-focused-tags 7";
          "Mod1 8" = "set-focused-tags 8";
          "Mod1 9" = "set-focused-tags 9";

          "Mod1+Shift 1" = "set-view-tags 1";
          "Mod1+Shift 2" = "set-view-tags 2";
          "Mod1+Shift 3" = "set-view-tags 3";
          "Mod1+Shift 4" = "set-view-tags 4";
          "Mod1+Shift 5" = "set-view-tags 5";
          "Mod1+Shift 6" = "set-view-tags 6";
          "Mod1+Shift 7" = "set-view-tags 7";
          "Mod1+Shift 8" = "set-view-tags 8";
          "Mod1+Shift 9" = "set-view-tags 9";

          "Mod1 0" = "set-focused-tags 0";
          "Mod1+Shift 0" = "set-view-tags 0";
        };
      };
      set-repeat = "50 300";
      spawn = [
        "thorium-browser"
        "ghostty"
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;
    settings = {
      "$mod" = "ALT";
      "$terminal" = "uwsm app -- ghostty";
      "$fileManager" = "uwsm app -- dolphin";
      "$menu" = "uwsm app -- $(wofi --show drun --define=drun-print_desktop_file=true)";
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
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
          "$mod SHIFT, J, layoutmsg, togglesplit, # dwindle"
          "$mod, SPACE, exec, $menu"
          "$mod SHIFT, S, exec, XDG_CURRENT_DESKTOP=sway flameshot gui"
          "$mod,F,fullscreen"
          "$mod,M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          "SUPER, Space, exec, ${pkgs.hyprland}/bin/hyprctl switchxkblayout next && ${pkgs.procps}/bin/pkill -RTMIN+1 waybar"
          "$mod, R, exec, ~/nixos/modules/nixos/external-monitor.sh"
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
      monitor = HDMI-A-1,2560x1440@143.85Hz, 0x0, 1

      xwayland {
        force_zero_scaling = true
      }

      #################
      ### AUTOSTART ###
      #################

      exec-once = dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans Medium 11'"
      exec-once = dconf write /org/gnome/desktop/interface/font-name "'Noto Sans Medium 11'"
      exec-once = dconf write /org/gnome/desktop/interface/monospace-font-name "'Noto Sans Mono Medium 11'"

      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      exec-once = [workspace 1 silent] ghostty
      exec-once = [workspace 2 silent] uwsm app -- thorium-browser
      exec-once = [workspace 3 silent] uwsm app -- Telegram
      exec-once = [workspace 4 silent] uwsm app -- mattermost-desktop
      exec-once = [workspace 5 silent] ghostty

      exec = ~/nixos/modules/nixos/external-monitor.sh

      exec-once = ${inputs.hyprpanel.packages.${pkgs.system}.default}/hyprpanel

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
          allow_tearing = true

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

          animation = global, 1, 2, default
          animation = border, 1, 1, easeOutQuint
          animation = windows, 1, 1, easeOutQuint
          animation = windowsIn, 1, 1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 0.5, linear, popin 87%
          animation = fadeIn, 1, 1, almostLinear
          animation = fadeOut, 1, 0.6, almostLinear
          animation = fade, 1, 1.0, quick
          animation = layers, 1, 1.0, easeOutQuint
          animation = layersIn, 1, 1.0, easeOutQuint, fade
          animation = layersOut, 1, 0.75, linear, fade
          animation = fadeLayersIn, 1, 0.7, almostLinear
          animation = fadeLayersOut, 1, 0.6, almostLinear
          animation = workspaces, 1, 0.75, almostLinear, fade
          animation = workspacesIn, 1, 0.55, almostLinear, fade
          animation = workspacesOut, 1, 0.75, almostLinear, fade
      }

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc {
          force_default_wallpaper = 0
          disable_hyprland_logo = true
      }

      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input {
          kb_layout = us,ru
          kb_options = grp:win_space_toggle

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

      # Fixes for flameshot on wayland
      windowrulev2 = float, class:^(flameshot)$
      windowrulev2 = move 0 0, class:^(flameshot)$
      windowrulev2 = pin, class:^(flameshot)$
      # set this to your leftmost monitor id, otherwise you have to move your cursor to the leftmost monitor
      # before executing flameshot
      windowrulev2 = monitor 1, class:^(flameshot)$

      windowrulev2 = fullscreen,class:^steam_app\d+$
      windowrulev2 = monitor 1,class:^steam_app_\d+$
      windowrulev2 = fullscreen,class:^(cs2)$
      windowrulev2 = fullscreen,class:^(csgo_linux64)$
      windowrulev2 = workspace 9,class:^steam_app_\d+$
      windowrulev2 = immediate,class:^(gamescope)$
      windowrulev2 = immediate,class:^(cs2)$
      windowrulev2 = immediate,class:^steam_app\d+$
      windowrulev2 = immediate,class:^(csgo_linux64)
      windowrulev2 = immediate,class:^(Golf With Your Friends\.x86_64)$
      windowrulev2 = immediate,class:^(valheim\.x86_64)$

      windowrulev2 = float,class:^(org.telegram.desktop|telegramdesktop)$,title:^(Media viewer)$

      ############
      ####WOFI####
      ############

      layerrule = blur, wofi
      layerrule = ignorezero, wofi
      layerrule = ignorealpha 0.5, wofi

      ############################
      #### SWAY NOTIFICATIONS ####
      ############################

      exec-once = uwsm finalize

      windowrulev2 = opacity 0.0 override, class:^(xwaylandvideobridge)$
      windowrulev2 = noanim, class:^(xwaylandvideobridge)$
      windowrulev2 = noinitialfocus, class:^(xwaylandvideobridge)$
      windowrulev2 = maxsize 1 1, class:^(xwaylandvideobridge)$
      windowrulev2 = noblur, class:^(xwaylandvideobridge)$
      windowrulev2 = nofocus, class:^(xwaylandvideobridge)$
    '';
  };

  programs.git = {
    enable = true;
    userName = "Art P.";
    userEmail = "fn3x@yandex.com";
    signing = {
      signByDefault = true;
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
    enable = false;
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
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      format = lib.concatStrings [
        "[](color_orange)"
        "$username"
        "[](bg:color_yellow fg:color_orange)"
        "$directory"
        "[](bg:color_yellow fg:color_orange)"
        "$git_branch"
        "$git_status"
        "[](fg:color_aqua bg:color_blue)"
        "$c"
        "$cpp"
        "$rust"
        "$golang"
        "$nodejs"
        "$php"
        "$java"
        "$kotlin"
        "$python"
        "[](fg:color_blue bg:color_bg3)"
        "$docker_context"
        "$conda"
        "$pixi"
        "[](fg:color_bg3 bg:color_bg1)"
        "$time"
        "[ ](fg:color_bg1)"
        "$line_break$character"
      ];
      palette = "gruvbox_dark";
      palettes.gruvbox_dark = {
        color_fg0 = "#fbf1c7";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };
      os = {
        disabled = false;
        style = "bg:color_orange fg:color_fg0";
        symbols = {
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          EndeavourOS = "";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
          Pop = "";
          NixOS = " ";
        };
      };
      username = {
        show_always = true;
        style_user = "bg:color_orange fg:color_fg0";
        style_root = "bg:color_orange fg:color_fg0";
        format = "[ $user ]($style)";
      };
      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music"     = "󰝚 ";
          "Pictures"  = " ";
          "Developer" = "󰲋 ";
        };
      };
      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = ''[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)'';
      };
      git_status = {
        style = "bg:color_aqua";
        format = ''[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)'';
      };
      nodejs = {
        symbol = "";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      c = {
        symbol = " ";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      cpp = {
        symbol = " ";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      rust = {
        symbol = "";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      golang = {
        symbol = "";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      php = {
        symbol = "";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      java = {
        symbol = "";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      kotlin = {
        symbol = "";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      haskell = {
        symbol = "";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      python = {
        symbol = "";
        style = "bg:color_blue";
        format = ''[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'';
      };
      docker_context = {
        symbol = "";
        style = "bg:color_bg3";
        format = ''[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)'';
      };
      conda = {
        style = "bg:color_bg3";
        format = ''[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)'';
      };
      pixi = {
        style = "bg:color_bg3";
        format = ''[[ $symbol( $version)( $environment) ](fg:color_fg0 bg:color_bg3)]($style)'';
      };
      time = {
        disabled = false;
        style = "bg:color_bg1";
        format = ''[[  $time ](fg:color_fg0 bg:color_bg1)]($style)'';
      };
      line_break = {
        disabled = false;
      };
      character = {
        disabled = false;
        success_symbol = "[](bold fg:color_green)";
        error_symbol = "[](bold fg:color_red)";
        vimcmd_symbol = "[](bold fg:color_green)";
        vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
        vimcmd_replace_symbol = "[](bold fg:color_purple)";
        vimcmd_visual_symbol = "[](bold fg:color_yellow)";
      };
    };
  };

  programs.nushell = {
    enable = true;
    settings = {
      buffer_editor = "nvim";
      show_banner = false;
    };
    envFile.text = ''
      do --env {
        let ssh_agent_file = (
            $nu.temp-path | path join $"ssh-agent-fn3x.nuon"
        )

        if ($ssh_agent_file | path exists) {
            let ssh_agent_env = open ($ssh_agent_file)
            if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) {
                load-env $ssh_agent_env
                return
            } else {
                rm $ssh_agent_file
            }
        }

        let ssh_agent_env = ^ssh-agent -c
            | lines
            | first 2
            | parse "setenv {name} {value};"
            | transpose --header-row
            | into record
        load-env $ssh_agent_env
        $ssh_agent_env | save --force $ssh_agent_file
        ^ssh-add ~/.ssh/id_bitbucket ~/.ssh/id_github
      }
    '';
    configFile.text = ''
      source ${nushell-theme}
      $env.config = {
        hooks: {
          pre_prompt: [{ ||
            if (which direnv | is-empty) {
              return
            }

            direnv export json | from json | default {} | load-env
            if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
              $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
            }
          }]
        }
      }
    '';
  };

  programs.zsh = {
    enable = false;
    enableCompletion = true;
    enableVteIntegration = true;
    autosuggestion.enable = true;
    dirHashes = {
      work = "~/work";
      personal = "~/personal";
      dl = "~/Downloads";
    };
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    envExtra = "eval \"$(direnv hook zsh)\"\n";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };

  programs.oh-my-posh = {
    enable = false;
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

    colorschemes.gruvbox = {
      enable = true;
      autoLoad = true;
      settings = {
        italic = {
          strings = false;
          emphasis = false;
          comments = true;
          operators = false;
          folds = false;
        };
        transparent_mode = true;
        invert_selection = false;
      };
    };

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
      ignorecase = true;
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
    };

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

    highlightOverride = {
      Pmenu = {
        bg = "none";
      };
    };

    plugins = {
      harpoon = {
        enable = true;
        settings = {
          settings = {
            save_on_toggle = true;
            sync_on_ui_close = true;
          };
        };
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
          lazygit = {
            configure = true;
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
          "<leader>ds" = {
            action = "lsp_document_symbols";
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

      lspkind = {
        enable = true;
      };

      blink-cmp = {
        enable = true;
        settings = {
          snippets = { preset = "luasnip"; };
          sources = {
            default = [ "lsp" "path" "snippets" "buffer" ];
          };
          completion = {
            ghost_text.enabled = false;
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 300;
            };
            menu = {
              auto_show = true;
              draw = {
                columns.__raw = ''{
                  { "label", "label_description", gap = 1 },
                  { "kind_icon", gap = 1, "kind" }
                }'';
                components = {
                  kind_icon = {
                    text.__raw = ''
                      function(ctx)
                        local lspkind = require("lspkind")
                        local icon = ctx.kind_icon
                        if vim.tbl_contains({ "Path" }, ctx.source_name) then
                            local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                            if dev_icon then
                                icon = dev_icon
                            end
                        else
                            icon = require("lspkind").symbolic(ctx.kind, {
                                mode = "symbol",
                            })
                        end

                        return icon .. ctx.icon_gap
                      end
                    '';
                    highlight.__raw = ''
                      function(ctx)
                        local hl = ctx.kind_hl
                        if vim.tbl_contains({ "Path" }, ctx.source_name) then
                          local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                          if dev_icon then
                            hl = dev_hl
                          end
                        end
                        return hl
                      end
                    '';
                  };
                };
              };
            };
          };
          keymap = {
            "<C-space>" = [
              "select_and_accept"
            ];
            "<C-y>" = [
              "show"
              "show_documentation"
              "hide_documentation"
            ];
          };
        };
      };

      lsp = {
        enable = true;
        inlayHints = false;
        keymaps = {
          silent = true;
          lspBuf = {
            "<leader>ca" = "code_action";
            "gd" = "definition";
            "gD" = "declaration";
          };
          extra = [
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
          protols = {
            enable = true;
          };
        };
      };
    };

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#b8fcec", bold = false });
      vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true });
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#fcd6a9", bold = false });

      vim.o.background = "dark"

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
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        silent = true,
      })

      vim.o.winborder = "rounded"
    '';
  };

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

  home.pointerCursor = {
    hyprcursor = {
      enable = true;
      size = 34;
    };
    package = inputs.mcmojave-hyprcursor.packages.x86_64-linux.default;
    name = "McMojave";
  };

  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      show = "drun";
      width = 500;
      height = 400;
      always_parse_args = true;
      show_all = true;
      term = "$TERMINAL";
      hide_scroll = true;
      print_command = true;
      insensitive = true;
      columns = 1;
    };
    style = ''
      @import url('${config.xdg.cacheHome}/wal/colors-waybar.css');

      @define-color mauve  @color9;
      @define-color red  @color9;
      @define-color lavender  @color7;
      @define-color text  @color7;

      * {
        font-family: 'CodeNewRoman Nerd Font Mono', monospace;
        font-size: 17px;
        outline: none;
        border: none;
      }
      window {
        all:unset;
        padding: 20px;
        border-radius: 10px;
        background-color: alpha(@background,.5);
        animation: fadeIn .5s ease-in-out;
      }
      /* Slide In */
      @keyframes slideIn {
        0% {
          opacity: 0;
        }
        100% {
          opacity: 1;
        }
      }
      #inner-box {
        margin: 2px;
        padding: 5px;
        border: none;
        background-color: @base;
        animation: slideIn 1s ease-in-out;
      }
      @keyframes fadeIn{
          0% {
            border-radius: 100px;
          }
          100% {
            border-radius: 10px;
          }
      }
      #outer-box {
        border-radius: .5em;
        border: none
        background-color: @base;
      }
      #scroll {
        margin: 0px;
        padding: 30px;
        border: none;
        background-color: @base;
        animation: fadeIn .8s ease-in-out;
      }
      #input {
        all:unset;
        margin-left:20px;
        margin-right:20px;
        margin-top:20px;
        padding: 20px;
        border: none;
        outline: none;
        color: @text;
        background-color: @base;
        animation: slideIn 1s ease-in-out;
        box-shadow: 1px 1px 5px rgba(0, 0, 0, .2);
        border-radius:10;
      }
      #input image {
        border: none;
        color: @red;
        outline: none;
      }
      #input * {
        border: none;
        border: none;
        outline: none;
      }
      #input:focus {
        outline: none;
        border: none;
        box-shadow: 1px 1px 5px rgba(0, 0, 0, .2);
        border-radius:10;
      }
      #text {
        margin: 5px;
        border: none;
        color: @text;
        outline: none;
      }
      #entry {
        background-color: @base;
        border: none;
      }
      #entry arrow {
        border: none;
        color: @lavender;
      }
      #entry:selected {
        box-shadow: 1px 1px 5px rgba(255,255,255, .03);
        border: none;
        border-radius:20;
      }
      #entry:selected #text {
        color: @mauve;
      }
      #entry:drop(active) {
        background-color: @lavender !important;
        animation: fadeIn 1s ease-in-out;
      }
    '';
  };

  programs.hyprpanel = {
    enable = true;
    package = inputs.hyprpanel.packages.${pkgs.system}.default;

    settings = {
      layout = {
        "bar.layouts" = {
          "0" = {
            left = [ "dashboard" "network" "bluetooth" "volume" "media" ];
            middle = [ "workspaces" ];
            right = [ "clock" "kbinput" "battery" "systray" "notifications" ];
          };
          "1" = {
            left = [ "dashboard" "network" "bluetooth" "volume" "media" ];
            middle = [ "workspaces" ];
            right = [ "clock" "kbinput" "battery" "systray" "notifications" ];
          };
          "2" = {
            left = [ "dashboard" "network" "bluetooth" "volume" "media" ];
            middle = [ "workspaces" ];
            right = [ "clock" "kbinput" "battery" "systray" "notifications" ];
          };
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.showApplicationIcons = true;
      bar.workspaces.showWsIcons = true;
      bar.workspaces.workspaces = 9;
      bar.systray.ignore = [ "Xwayland Video Bridge_pipewireToXProxy" "blueman" ];
      bar.clock.format = "%d %b %H:%M:%S";

      menus.clock.weather.enabled = false;
      menus.dashboard.shortcuts.enabled = false;
      menus.clock.time.military = true;

      notifications.ignore = [ "spotify" ];
      tear = true;

      theme.name = "gruvbox";
      theme.osd.location = "left";
      theme.font.name = "SFProDisplay Nerd Font";
      theme.font.size = "1.3rem";
      theme.bar.transparent = true;

      wallpaper.enable = true;
      wallpaper.image = "~/wallpapers/bg.jpg";

      menus.dashboard.directories.left.directory1.command = "dolphin Downloads";
      menus.dashboard.directories.left.directory1.label = "󰉍 Downloads";
      menus.dashboard.directories.left.directory2.command = "dolphin Videos";
      menus.dashboard.directories.left.directory2.label = "󰉏 Videos";
      menus.dashboard.directories.left.directory3.command = "dolphin personal";
      menus.dashboard.directories.left.directory3.label = "󰚝 Personal";
      menus.dashboard.directories.right.directory1.command = "dolphin Documents";
      menus.dashboard.directories.right.directory1.label = "󱧶 Documents";
      menus.dashboard.directories.right.directory2.command = "dolphin Pictures";
      menus.dashboard.directories.right.directory2.label = "󰉏 Pictures";
      menus.dashboard.directories.right.directory3.command = "dolphin ./";
      menus.dashboard.directories.right.directory3.label = "󱂵 Home";
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs pkgs.obs-studio-plugins.obs-backgroundremoval pkgs.obs-studio-plugins.obs-pipewire-audio-capture ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
