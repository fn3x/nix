{
inputs,
pkgs,
lib,
config,
...
}:
{
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    home.file = {
      "${config.xdg.configHome}/.config/uwsm/env-hyprland" = {
        text = ''
        export HYPRLAND_NO_SD_VARS=1
        '';
        executable = false;
      };
    };

    programs.kitty.enable = true; # required for the default Hyprland config

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      xwayland.enable = true;
      package = null;
      portalPackage = null;
      settings = {
        "$mod" = "ALT";
        "$terminal" = "${pkgs.uwsm}/bin/uwsm app -- ${inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ghostty";
        "$fileManager" = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.kdePackages.dolphin}/bin/dolphin";
        "$menu" = "${inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/vicinae toggle";
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
            "$mod, J, togglesplit, # dwindle"
            "$mod, SPACE, exec, $menu"
            "$mod SHIFT, S, exec, XDG_CURRENT_DESKTOP=sway flameshot gui"
            "$mod,F,fullscreen"
            "$mod,M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            "SUPER, Space, exec, ${pkgs.hyprland}/bin/hyprctl switchxkblayout next"
            "$mod SHIFT, P, exec, ${pkgs.normcap}/bin/normcap"
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
        monitor = "DP-1, 2560x1440@170.00Hz, 0x0, 1";
        xwayland = {
          force_zero_scaling = true;
          create_abstract_socket = true;
        };
        general = {
          gaps_in = 10;
          gaps_out = 5;

          border_size = 1;

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = true;

          layout = "dwindle";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 10;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        animations = {
          enabled = "no";
        };

        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        dwindle = {
          pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # You probably want this
        };

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input = {
          kb_layout = "us,ru";
          kb_options = "grp:win_space_toggle";

          follow_mouse = 1;

          sensitivity = 0; # 0 means no modification.
          repeat_delay = 300;
          repeat_rate = 50;
        };
      };
      extraConfig = ''
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      exec-once = [workspace 1 silent] $terminal
      exec-once = [workspace 2 silent] uwsm app -- brave
      exec-once = [workspace 3 silent] uwsm app -- Telegram
      exec-once = [workspace 4 silent] uwsm app -- mattermost-desktop
      exec-once = [workspace 5 silent] uwsm app -- spotify
      exec-once = ${inputs.hyprpanel.packages.${pkgs.stdenv.hostPlatform.system}.default}/hyprpanel

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      windowrule {
        name = ignore-maximize
        match:class = .*
        suppress_event = maximize
      }

      windowrule {
          # Fix some dragging issues with XWayland
          name = fix-xwayland-drags
          match:class = ^$
          match:title = ^$
          match:xwayland = true
          match:float = true
          match:fullscreen = false
          match:pin = false

          no_focus = true
      }

      windowrule {
        name = flameshot
        match:class = ^(flameshot)$
        move = 0 0
        pin = true
        monitor = 1
      }

      windowrule {
        name = steam-games
        match:class = ^steam_app\.*$
        fullscreen = true
        monitor = 1
        immediate = true
        workspace = 9
      }

      windowrule {
        name = gamescope
        match:class = ^gamescope\.*$
        fullscreen = true
        monitor = 1
        immediate = true
        workspace = 9
      }

      windowrule {
        name = cs2
        match:class = ^cs2\.*$
        fullscreen = true
        monitor = 1
        immediate = true
        workspace = 9
      }

      windowrule {
        name = csgo
        match:class = ^csgo_\.*$
        fullscreen = true
        monitor = 1
        immediate = true
        workspace = 9
      }

      windowrule {
        name = csgo
        match:class = ^Golf With Your Friends\.*$
        fullscreen = true
        monitor = 1
        immediate = true
        workspace = 9
      }

      windowrule {
        name = telegram-media
        match:class = ^(org.telegram.desktop|telegramdesktop)$
        match:title = ^(Media viewer)$
        float = true
      }

      layerrule {
        name = vicinae-layer
        match:namespace = vicinae
        blur = true
        ignore_alpha = 0
        no_anim = true
      }

      exec-once = uwsm finalize
      '';
    };
  };
}
