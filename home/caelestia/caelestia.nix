{
lib,
config,
pkgs,
inputs,
...
}:
{
  options = {
    caelestia.enable = lib.mkEnableOption "enables caelestia";
  };

  config = lib.mkIf config.caelestia.enable {
    programs.caelestia = {
      enable = true;
      systemd = {
        enable = true;
      };
      settings = {
        appearance = {
          anim = {
            durations = {
              scale = 1;
            };
          };
          padding = {
            scale = 1;
          };
          rounding = {
            scale = 1;
          };
          spacing = {
            scale = 1;
          };
          transparency = {
            enabled = false;
            base = {
            };
            layers = {
            };
          };
        };
        general = {
          apps = {
            terminal = [
              "${inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ghostty"
            ];
            audio = [
              "${pkgs.pavucontrol}/bin/pavucontrol"
            ];
            playback = [
              "${pkgs.vlc}/bin/vlc"
            ];
            explorer = [
              "${pkgs.kdePackages.dolphin}/bin/dolphin"
            ];
          };
          idle = {
            lockBeforeSleep = true;
            inhibitWhenAudio = true;
            timeouts = [
              {
                timeout = 180;
                idleAction = "lock";
              }
              {
                timeout = 300;
                idleAction = "dpms off";
                returnAction = "dpms on";
              }
              {
                timeout = 600;
                idleAction = [
                  "systemctl"
                  "suspend-then-hibernate"
                ];
              }
            ];
          };
        };
        background = {
          desktopClock = {
            enabled = true;
          };
          enabled = true;
          visualiser = {
            blur = false;
            enabled = false;
            autoHide = true;
            rounding = 1;
            spacing = 1;
          };
        };
        bar = {
          clock = {
            showIcon = true;
          };
          dragThreshold = 20;
          entries = [
            {
              id = "logo";
              enabled = true;
            }
            {
              id = "workspaces";
              enabled = true;
            }
            {
              id = "spacer";
              enabled = true;
            }
            {
              id = "activeWindow";
              enabled = true;
            }
            {
              id = "spacer";
              enabled = true;
            }
            {
              id = "tray";
              enabled = true;
            }
            {
              id = "clock";
              enabled = true;
            }
            {
              id = "statusIcons";
              enabled = true;
            }
          ];
          persistent = true;
          popouts = {
            activeWindow = true;
            statusIcons = true;
            tray = true;
          };
          scrollActions = {
            brightness = true;
            workspaces = true;
            volume = true;
          };
          showOnHover = false;
          status = {
            showAudio = true;
            showBattery = false;
            showBluetooth = false;
            showKbLayout = false;
            showMicrophone = true;
            showNetwork = false;
            showLockStatus = false;
          };
          tray = {
            background = false;
            compact = false;
            iconSubs = [
            ];
            recolour = false;
          };
          workspaces = {
            activeIndicator = true;
            activeLabel = "󰮯";
            activeTrail = false;
            label = "  ";
            occupiedBg = false;
            occupiedLabel = "󰮯";
            perMonitorWorkspaces = true;
            showWindows = true;
            shown = 10;
            specialWorkspaceIcons = [
              {
                name = "steam";
                icon = "sports_esports";
              }
            ];
          };
          excludedScreens = [
            ""
          ];
          activeWindow = {
            inverted = false;
          };
        };
        border = {
          rounding = 25;
          thickness = 10;
        };
        dashboard = {
          enabled = true;
          dragThreshold = 50;
          mediaUpdateInterval = 500;
          showOnHover = true;
        };
        lock = {
          recolourLogo = false;
        };
        notifs = {
          actionOnClick = true;
          clearThreshold = {
          };
          defaultExpireTimeout = 5000;
          expandThreshold = 20;
          expire = false;
        };
        osd = {
          enabled = true;
          enableBrightness = false;
          enableMicrophone = true;
          hideDelay = 2000;
        };
        paths = {
          mediaGif = "root:/assets/bongocat.gif";
          sessionGif = "root:/assets/kurukuru.gif";
          wallpaperDir = "~/wallpapers";
        };
        services = {
          audioIncrement = {
          };
          maxVolume = 1;
          defaultPlayer = "Spotify";
          gpuType = "";
          playerAliases = [
            {
              from = "com.github.th_ch.youtube_music";
              to = "YT Music";
            }
          ];
          weatherLocation = "";
          useFahrenheit = false;
          useTwelveHourClock = false;
          smartScheme = true;
          visualiserBars = 45;
        };
        session = {
          dragThreshold = 30;
          enabled = true;
          vimKeybinds = true;
          commands = {
            logout = [
              "loginctl"
              "terminate-user"
              ""
            ];
            shutdown = [
              "systemctl"
              "poweroff"
            ];
            hibernate = [
              "systemctl"
              "hibernate"
            ];
            reboot = [
              "systemctl"
              "reboot"
            ];
          };
        };
        sidebar = {
          dragThreshold = 80;
          enabled = true;
        };
        utilities = {
          enabled = true;
          maxToasts = 4;
          toasts = {
            audioInputChanged = true;
            audioOutputChanged = true;
            capsLockChanged = false;
            chargingChanged = true;
            configLoaded = true;
            dndChanged = true;
            gameModeChanged = true;
            kbLayoutChanged = false;
            numLockChanged = true;
            vpnChanged = true;
            nowPlaying = true;
          };
          vpn = {
            enabled = true;
            provider = [
              {
                name = "wireguard";
                interface = "aws";
                displayName = "Wireguard";
              }
            ];
          };
        };
      };
      cli = {
        enable = true;
      };
    };
  };
}
