{
inputs,
pkgs,
lib,
config,
...
}:
{
  options = {
    ghostty.enable = lib.mkEnableOption "enables ghostty";
  };

  config = lib.mkIf config.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        font-family = "Berkeley Mono";
        font-size = 20;
        theme = "Apple System Colors";
        cursor-style = "block";
        cursor-opacity = 1;
        cursor-color = "cell-foreground";
        cursor-text = "cell-background";
        background-blur-radius = 20;
        background-opacity = 0.95;
        title = "";
        window-save-state = "always";
        window-decoration = false;
        auto-update = "check";
        shell-integration = "none";
        shell-integration-features = "ssh-env, ssh-terminfo";
        mouse-hide-while-typing = true;
        keybind = [
          "ctrl+b>u=scroll_page_fractional:-0.5"
          "ctrl+b>d=scroll_page_fractional:0.5"

          "ctrl+b>ctrl+j=new_split:down"
          "ctrl+b>ctrl+k=new_split:up"
          "ctrl+b>ctrl+h=new_split:left"
          "ctrl+b>ctrl+l=new_split:right"
          "ctrl+b>c=new_split:auto"
          "ctrl+shift+w=close_surface"

          "ctrl+b>j=goto_split:down"
          "ctrl+b>k=goto_split:up"
          "ctrl+b>h=goto_split:left"
          "ctrl+b>l=goto_split:right"
          "ctrl+b>n=goto_split:next"
          "ctrl+b>p=goto_split:previous"

          "ctrl+b>f=toggle_split_zoom"

          "ctrl+b>t=new_tab"

          "ctrl+b>1=goto_tab:1"
          "ctrl+b>2=goto_tab:2"
          "ctrl+b>3=goto_tab:3"
          "ctrl+b>4=goto_tab:4"
          "ctrl+b>5=goto_tab:5"
          "ctrl+b>6=goto_tab:6"
          "ctrl+b>7=goto_tab:7"
          "ctrl+b>8=goto_tab:8"
          "ctrl+b>9=goto_tab:9"

          "ctrl+b>shift+j=resize_split:down,10"
          "ctrl+b>shift+k=resize_split:up,10"
          "ctrl+b>shift+h=resize_split:left,10"
          "ctrl+b>shift+l=resize_split:right,10"

          "ctrl+b>equal=equalize_splits"

          "ctrl+b>s=toggle_tab_overview"

          "ctrl+shift+p=toggle_command_palette"
        ];
      };
    };
  };
}
