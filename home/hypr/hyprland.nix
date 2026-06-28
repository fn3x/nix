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
    programs.kitty.enable = true; # required for the default Hyprland config

    home.packages = with pkgs; [
      catppuccin-cursors.mochaDark
      inputs.hyprpwcenter.packages.${system}.default
    ];

    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

    home.sessionVariables = {
      XCURSOR_THEME = "Catppuccin Mocha Dark";
      XCURSOR_SIZE = 22;
    };

    xdg.portal = {
      enable = lib.mkForce true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      xwayland.enable = true;
      package = null;
      portalPackage = null;
      configType = "lua";
      settings = {
        mod = {
          _var = "ALT";
        };
        bind = [
          {
            _args = [
              "XF86AudioPlay"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
            ];
          }
          {
            _args = [
              "XF86AudioNext"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")")
            ];
          }
          {
            _args = [
              "XF86AudioPrev"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")")
            ];
          }
          {
            _args = [
              "XF86AudioRaiseVolume"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+\")")
            ];
          }
          {
            _args = [
              "XF86AudioLowerVolume"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
            ];
          }
          {
            _args = [
              "XF86AudioMute"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
            ];
          }
          {
            _args = [
              "XF86AudioMicMute"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
            ];
          }
          {
            _args = [
              "XF86MonBrightnessUp"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl s 10%+\")")
            ];
          }
          {
            _args = [
              "XF86MonBrightnessDown"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl s 10%-\")")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + mouse:272\"")
              (lib.generators.mkLuaInline "hl.dsp.window.drag()")
              { mouse = true; drag = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + H\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"left\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + L\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"right\"})")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + K\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"up\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + J\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"down\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + H\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"left\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + L\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"right\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + K\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"up\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + J\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"down\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + T\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.uwsm}/bin/uwsm app -- ${pkgs.ghostty}/bin/ghostty\")")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + Q\"")
              (lib.generators.mkLuaInline "hl.dsp.window.kill()")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + M\"")
              (lib.generators.mkLuaInline "hl.dsp.exit()")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + E\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.uwsm}/bin/uwsm app -- ${pkgs.kdePackages.dolphin}/bin/dolphin\")")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + V\"")
              (lib.generators.mkLuaInline "hl.dsp.window.float()")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SPACE\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/vicinae toggle\")")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + F\"")
              (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
            ];
          }
          {
            _args = [
              "SUPER + SPACE"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.hyprland}/bin/hyprctl switchxkblayout next\")")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + 1\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"1\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + 1\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"1\", follow = false })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + 2\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"2\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + 2\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"2\", follow = false })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + 3\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"3\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + 3\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"3\", follow = false })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + 4\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"4\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + 4\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"4\", follow = false })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + 5\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"5\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + 5\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"5\", follow = false })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + 6\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"6\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + 6\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"6\", follow = false })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + 7\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"7\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + 7\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"7\", follow = false })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + 8\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"8\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + 8\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"8\", follow = false })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + 9\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"9\" })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + 9\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"9\", follow = false })")
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + EQUAL\"")
              (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 100, y = 0, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + MINUS\"")
              (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = -100, y = 0, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + EQUAL\"")
              (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = 100, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + MINUS\"")
              (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = -100, relative = true })")
              { repeating = true; }
            ];
          }
        ];
        on = {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline "function()
  hl.exec_cmd(\"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP\")
  hl.exec_cmd(\"hyprctl setcursor 'Catppuccin Mocha Dark' 22\")
  hl.exec_cmd(\"${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia-shell\")
  hl.exec_cmd(\"${pkgs.uwsm}/bin/uwsm app -- ${pkgs.ghostty}/bin/ghostty\", { workspace = \"1\" })
  hl.exec_cmd(\"${pkgs.uwsm}/bin/uwsm app -- ${inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/helium\", { workspace = \"2\" })
  hl.exec_cmd(\"${pkgs.uwsm}/bin/uwsm app -- ${pkgs.telegram-desktop}/bin/Telegram\", { workspace = \"3\" })
  hl.exec_cmd(\"${pkgs.uwsm}/bin/uwsm app -- ${pkgs.mattermost-desktop}/bin/mattermost-desktop\", { workspace = \"3\" })
  hl.exec_cmd(\"${pkgs.uwsm}/bin/uwsm app -- ${pkgs.spotify}/bin/spotify\", { workspace = \"5\" })
  hl.exec_cmd(\"${pkgs.uwsm}/bin/uwsm app -- ${pkgs.steam}/bin/steam\", { workspace = \"6\" })
end")
          ];
        };
        monitor = {
          scale = "1.25";
          mode = "2560x1440@170.00Hz";
          position = "auto";
          output = "";
        };
        config = {
          animations = {
            enabled = true;
          };
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

            layout = "scrolling";
          };

          scrolling = {
            explicit_column_widths = "0.333, 0.5, 0.667, 1.0";
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

          # https://wiki.hyprland.org/Configuring/Variables/#input
          input = {
            kb_layout = "us,ru";
            kb_options = "grp:win_space_toggle";

            follow_mouse = 1;

            sensitivity = 0; # 0 means no modification.
            repeat_delay = 300;
            repeat_rate = 50;
          };


          # https://wiki.hyprland.org/Configuring/Variables/#misc
          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
          };
        };
      };
      extraConfig = ''
      hl.window_rule({
        name = "ignore-maximize",
        match = {
         class = ".*"
        },
        suppress_event = "maximize"
      })

      -- Fix some dragging issues with XWayland
      hl.window_rule({
        name = "fix-xwayland-drags",
        match = {
         class = "^$",
         title = "^$",
         class = "^$",
         class = "^$",
         xwayland = true,
         float = true,
         fullscreen = true,
         pin = false,
        },
        no_focus = true,
      })

      hl.window_rule({
        name = "steam-games",
        match = {
         class = "^steam_app\\.*$"
        },
        fullscreen = true,
        immediate = true,
      })

      hl.window_rule({
        name = "gamescope",
        match = {
         class = "^gamescope\\.*$"
        },
        fullscreen = true,
        immediate = true,
      })

      hl.layer_rule({
        name = "vicinae-blur",
        match = {
         namespace = "vicinae"
        },
        blur = true,
        ignore_alpha = 0,
      })

      hl.curve("rubber", { type = "spring", mass = 1, stiffness = 120, dampening = 16 } )

      hl.animation({ leaf = "windows", enabled = true, speed = 10, spring = "rubber" })

      hl.animation({ leaf = "border", enabled = false, speed = 10, bezier = "md3_decel" })
      hl.animation({ leaf = "fade", enabled = false, speed = 10, bezier = "md3_decel" })
      hl.animation({ leaf = "workspaces", enabled = false, speed = 10, bezier = "md3_decel", style = "slide" })
      hl.animation({ leaf = "specialWorkspace", enabled = false, speed = 10, bezier = "md3_decel", style = "slidevert" })
      '';
    };
  };
}
