{
lib,
config,
...
}:
{
  options = {
    wofi.enable = lib.mkEnableOption "enables wofi";
  };

  config = lib.mkIf config.wofi.enable {
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
  };
}
