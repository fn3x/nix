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
            end = [ "keyboard_layout" "tray" "notifications" ];
            margin_ends = 10;
            scale = 1.25;
            start = [ "volume" "media" ];
            thickness = 40;
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
