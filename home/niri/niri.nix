{
inputs,
pkgs,
lib,
config,
...
}:
{
  options = {
    niri.enable = lib.mkEnableOption "enables niri";
  };

  config = lib.mkIf config.niri.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    home.packages = with pkgs; [
      xwayland-satellite
    ];

    services.wl-clip-persist = {
      enable = true;
      clipboardType = "regular";
    };

    programs.niri = let
      terminal = "${inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ghostty";
      browser = "${pkgs.brave}/bin/brave";
      fileManager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
    in {
      enable = true;
      package = pkgs.niri-unstable;
      settings = {
        prefer-no-csd = true;
        gestures = {
          hot-corners.enable = false;
        };
        hotkey-overlay = {
          skip-at-startup = true;
        };
        animations = {
          workspace-switch = {
            spring = {
              damping-ratio = 1.0;
              stiffness = 5000;
              epsilon = 0.0001;
            };
          };
        };
        layout = {
          empty-workspace-above-first = true;
          focus-ring = {
            width = 2;
            active = {
              gradient = {
                relative-to = "workspace-view";
                from = "#292F56";
                to = "#4734BE";
              };
            };
          };
        };
        input = {
          mod-key = "Alt";
          focus-follows-mouse.enable = true;
          warp-mouse-to-focus.enable = false;
          keyboard = {
            track-layout = "global";
            repeat-delay = 300;
            repeat-rate = 50;
            xkb = {
              layout = "us,ru";
              model = "kinesis";
              options = "grp:win_space_toggle";
            };
          };
        };
        outputs = {
          "DP-1" = {
            enable = true;
            mode = {
              width = 2560;
              height = 1440;
            };
            scale = 1.25;
          };
        };
        cursor = {
          size = 22;
          theme = "Catppuccin Mocha Dark";
        };
        binds = with config.lib.niri.actions; let
          pactl = "${pkgs.pulseaudio}/bin/pactl";

          volume-up = spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "+5%" ];
          volume-down = spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "-5%" ];
          appLauncher = spawn "${inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/vicinae" ["toggle"];
          baseBinds = {
            "XF86AudioRaiseVolume".action = volume-up;
            "XF86AudioLowerVolume".action = volume-down;
            "XF86AudioPlay".action = spawn ["playerctl" "play-pause"];
            "XF86AudioNext".action = spawn ["playerctl" "next"];
            "XF86AudioPrev".action = spawn ["playerctl" "previous"];
            "XF86AudioMute".action = spawn ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
            "XF86AudioMicMute".action = spawn ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];

            "Mod+T".action = spawn terminal;
            "Mod+B".action = spawn browser;
            "Mod+E".action = spawn fileManager;
            "Mod+Space".action = appLauncher;
            "Mod+Shift+S".action = spawn ["${pkgs.grim}/bin/grim" "-g" "\"$(${pkgs.slurp}/bin/slurp -d)\"" "-" "|" "${pkgs.satty}/bin/satty" "--filename" "-" "--output-filename" "\"./screenshot-%+.png\""];

            "Mod+Shift+Q".action = close-window;
            "Mod+V".action = toggle-window-floating;
            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+M".action = maximize-window-to-edges;
            "Mod+W".action = toggle-column-tabbed-display;
            "Mod+Return".action = toggle-overview;

            "Mod+H".action = focus-column-left;
            "Mod+L".action = focus-column-right;
            "Mod+J".action = focus-workspace-down;
            "Mod+K".action = focus-workspace-up;

            "Mod+Shift+H".action = move-column-left;
            "Mod+Shift+L".action = move-column-right;
            "Mod+Shift+J".action = move-column-to-workspace-down;
            "Mod+Shift+K".action = move-column-to-workspace-up;

            "Mod+1".action = focus-workspace "terminal";
            "Mod+2".action = focus-workspace "browser";
            "Mod+3".action = focus-workspace "messengers";
            "Mod+4".action = focus-workspace "work";
            "Mod+5".action = focus-workspace "music";
            "Mod+6".action = focus-workspace "games";
          };
          noctaliaBinds = lib.optionalAttrs config.noctalia.enable {
            # "Mod+S".action = spawn ["qs" "-c" "noctalia-shell" "ipc" "call" "plugin:notes-scratchpad" "togglePanel"];
          };
        in 
          baseBinds // noctaliaBinds;
        spawn-at-startup = [
          { command = ["dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"]; }
          { command = ["${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia-shell"]; }
          { command = ["${pkgs.xwayland-satellite}/bin/xwayland-satellite"]; }
          { command = [terminal]; }
          { command = [browser]; }
          { command = ["${pkgs.mattermost-desktop}/bin/mattermost-desktop"]; }
          { command = ["${pkgs.telegram-desktop}/bin/Telegram"]; }
          { command = ["${pkgs.spotify}/bin/spotify"]; }
          { command = ["${pkgs.teamspeak6-client}/bin/TeamSpeak"]; }
          { command = ["${pkgs.steam}/bin/steam"]; }
        ];
        workspaces = {
          "01-terminal" = {
            name = "terminal";
          };
          "02-browser" = {
            name = "browser";
          };
          "03-messengers" = {
            name = "messengers";
          };
          "04-work" = {
            name = "work";
          };
          "05-music" = {
            name = "music";
          };
          "06-games" = {
            name = "games";
          };
        };
        window-rules = [
          {
            open-maximized = true;
            border.enable = false;
            geometry-corner-radius = {
              top-left = 20.0;
              top-right = 20.0;
              bottom-left = 20.0;
              bottom-right = 20.0;
            };
            clip-to-geometry = true;
          }
          {
            matches = [
              {
                app-id = "com.mitchellh.ghostty";
                at-startup = true;
              }
            ];
            open-on-workspace = "terminal";
          }
          {
            matches = [
              {
                app-id = "brave-browser";
                at-startup = true;
              }
            ];
            open-on-workspace = "browser";
            open-focused = false;
          }
          {
            matches = [
              {
                app-id = "org.telegram.desktop";
                at-startup = true;
              }
            ];
            open-on-workspace = "messengers";
            open-focused = false;
            block-out-from = "screencast";
          }
          {
            matches = [
              {
                app-id = "teamspeak-client";
                at-startup = true;
              }
            ];
            open-on-workspace = "messengers";
            open-focused = false;
          }
          {
            matches = [
              {
                app-id = "Mattermost";
                at-startup = true;
              }
            ];
            open-on-workspace = "messengers";
            open-focused = false;
          }
          {
            matches = [
              {
                app-id = "spotify";
                at-startup = true;
              }
            ];
            open-on-workspace = "music";
            open-focused = false;
          }
          {
            matches = [
              {
                app-id = "steam";
                at-startup = true;
              }
            ];
            open-on-workspace = "games";
            open-focused = false;
          }
          {
            matches = [
              {
                app-id = "^org\\.telegram\\.desktop$";
                title = "^Media viewer$";
              }
            ];
            open-fullscreen = false;
          }
          {
            matches = [
              {
                app-id = "steam";
                title = "^notificationtoasts_\\d+_desktop$";
              }
            ];
          }
          {
            matches = [
              {
                app-id = "^org\\.telegram\\.desktop$";
              }
            ];
            block-out-from = "screencast";
          }
        ];
        debug = {
          honor-xdg-activation-with-invalid-serial = true;
        };
      };
    };
  };
}
