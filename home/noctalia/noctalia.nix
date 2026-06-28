{
lib,
config,
pkgs,
...
}:
{
  options = {
    noctalia.enable = lib.mkEnableOption "enables noctalia";
  };

  config = lib.mkIf config.noctalia.enable {
    home.packages = with pkgs; [
      networkmanagerapplet
    ];

    programs.noctalia = {
      enable = true;
      settings = {
        bar = {
          default = {
            capsule = true;
            center = [ "group:g1" ];
            end = [ "keyboard_layout" "sysmon" "tray" "notifications" ];
            margin_ends = 10;
            scale = 1.25;
            start = [ "group:g2" "media" "privacy" ];
            thickness = 40;

            capsule_group = [
              {
                fill = "surface_variant";
                id = "g1";
                members = [ "date" "clock" ];
                opacity = 1.0;
                padding = 6.0;
              }
              {
                fill = "surface_variant";
                id = "g2";
                members = [ "input_volume" "volume" ];
                opacity = 1.0;
                padding = 6.0;
              }
            ];
          };
        };

        control_center = {
          sidebar_section = "none";

          shortcuts = [
            { type = "bluetooth"; }
            { type = "audio"; }
            { type = "mic_mute"; }
            { type = "weather"; }
            { type = "nightlight"; }
          ];
        };

        desktop_widgets = {
          schema_version = 2;
          widget_order = [
            "desktop-widget-0000000000000001"
            "desktop-widget-0000000000000003"
            "desktop-widget-0000000000000004"
            "desktop-widget-0000000000000005"
            "desktop-widget-0000000000000006"
          ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget = {
            desktop-widget-0000000000000001 = {
              box_height = 192.0;
              box_width = 336.0;
              cx = 248.0;
              cy = 272.0;
              output = "DP-1";
              rotation = 0.0;
              type = "clock";

              settings = {
                center_text = false;
                clock_style = "digital";
                format = "{:%H:%M:%S}";
                shadow = true;
              };
            };

            desktop-widget-0000000000000003 = {
              box_height = 160.0;
              box_width = 352.0;
              cx = 608.0;
              cy = 480.0;
              output = "DP-1";
              rotation = 0.0;
              type = "media_player";
            };

            desktop-widget-0000000000000004 = {
              box_height = 192.0;
              box_width = 352.0;
              cx = 608.0;
              cy = 272.0;
              output = "DP-1";
              rotation = 0.0;
              type = "weather";
            };

            desktop-widget-0000000000000005 = {
              box_height = 144.0;
              box_width = 352.0;
              cx = 416.0;
              cy = 664.0;
              output = "DP-1";
              rotation = 0.0;
              type = "fancy_audio_visualizer";

              settings = {
                background = false;
              };
            };

            desktop-widget-0000000000000006 = {
              box_height = 160.0;
              box_width = 336.0;
              cx = 248.0;
              cy = 480.0;
              output = "DP-1";
              rotation = 0.0;
              type = "sysmon";

              settings = {
                stat = "cpu_usage";
                stat2 = "cpu_temp";
              };
            };
          };
        };

        location = {
          address = "Yerevan";
        };

        lockscreen_widgets = {
          enabled = false;
          schema_version = 2;
          widget_order = [ "lockscreen-login-box@DP-1" ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget."lockscreen-login-box@DP-1" = {
            box_height = 70.0;
            box_width = 400.0;
            cx = 1024.0;
            cy = 1033.0;
            output = "DP-1";
            rotation = 0.0;
            type = "login_box";

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };
        };

        notification = {
          scale = 0.85;
          show_actions = false;
        };

        osd = {
          orientation = "vertical";
          position = "top_center";
          position_vertical = "center_left";

          kinds = {
            media = false;
          };
        };

        shell = {
          app_icon_color = "hover";
          clipboard_enabled = false;
          corner_radius_scale = 0.75;
          screen_time_enabled = true;
          ui_scale = 1.15;

          animation = {
            speed = 1.5;
          };

          panel = {
            floating_offset = 9;
            open_near_click_clipboard = true;
            open_near_click_control_center = true;
            open_near_click_launcher = true;
            open_near_click_wallpaper = true;
            transparency_mode = "glass";
          };
        };

        theme = {
          builtin = "Gruvbox";
        };

        wallpaper = {
          directory = "${config.home.homeDirectory}/Wallpapers";

          automation = {
            enabled = true;
            interval_seconds = 3600;
          };
        };

        widget = {
          clock = {
            format = "{:%H:%M:%S}";
          };

          tray = {
            hidden = [ "Xwayland Video Bridge" "nm-applet" ];
            scale = 1.2;
          };
        };
      };
    };
  };
}
