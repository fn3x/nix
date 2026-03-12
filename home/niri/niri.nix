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
    };

    home.packages = with pkgs; [
      xwayland-satellite
    ];

    programs.niri = let
      terminal = "${inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ghostty";
      browser = "${pkgs.brave}/bin/brave";
      fileManager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
    in {
      enable = true;
      package = pkgs.niri-unstable;
      settings = {
        environment = {
          ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        };
        prefer-no-csd = true;
        hotkey-overlay = {
          skip-at-startup = true;
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
        in {
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

          "Mod+Shift+Q".action = close-window;
          "Mod+V".action = toggle-window-floating;
          "Mod+Shift+F".action = maximize-window-to-edges;
          "Mod+F".action = maximize-column;
          "Mod+W".action = toggle-column-tabbed-display;
          "Mod+Return".action = toggle-overview;

          "Mod+Left".action = focus-column-left;
          "Mod+Right".action = focus-column-right;
          "Mod+Down".action = focus-workspace-down;
          "Mod+Up".action = focus-workspace-up;

          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+J".action = focus-workspace-down;
          "Mod+K".action = focus-workspace-up;

          "Mod+Shift+Left".action = move-column-left;
          "Mod+Shift+Right".action = move-column-right;
          "Mod+Shift+Down".action = move-column-to-workspace-down;
          "Mod+Shift+Up".action = move-column-to-workspace-up;

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
          "Mod+7".action = focus-workspace "extra";
        };
        spawn-at-startup = [
          { command = [terminal]; }
          { command = [browser]; }
          { command = ["${pkgs.xwayland-satellite}/bin/xwayland-satellite"]; }
          { command = ["${pkgs.telegram-desktop}/bin/Telegram"]; }
          { command = ["${pkgs.mattermost-desktop}/bin/mattermost-desktop"]; }
          { command = ["${pkgs.spotify}/bin/spotify"]; }
          { command = ["${pkgs.teamspeak6-client}/bin/TeamSpeak"]; }
          { command = ["${pkgs.steam}/bin/steam"]; }
        ];
        workspaces = {
          terminal = {
            name = "terminal";
          };
          browser = {
            name = "browser";
          };
          messengers = {
            name = "messengers";
          };
          work = {
            name = "work";
          };
          music = {
            name = "music";
          };
          games = {
            name = "games";
          };
          extra = {
            name = "extra";
          };
        };
        window-rules = [
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
          }
          {
            matches = [
              {
                app-id = "org.telegram.desktop";
                at-startup = true;
              }
            ];
            open-on-workspace = "messengers";
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
          }
          {
            matches = [
              {
                app-id = "Mattermost";
                at-startup = true;
              }
            ];
            open-on-workspace = "messengers";
          }
          {
            matches = [
              {
                app-id = "Spotify";
                at-startup = true;
              }
            ];
            open-on-workspace = "music";
          }
          {
            matches = [
              {
                app-id = "steam";
                at-startup = true;
              }
            ];
            open-on-workspace = "games";
          }
        ];
        layer-rules = [
          {
            matches = [
              {
                namespace = "^notifications$";
              }
            ];
            block-out-from = "screencast";
          }
        ];
      };
    };
  };
}
