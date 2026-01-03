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
    home.sessionVariables = {
      TERMINAL = "ghostty";
    };

    programs.ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
      installVimSyntax = true;
      settings = {
        font-family = "Berkeley Mono";
        font-size = 18;
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
          
          # Vim-mode keybindings for Ghostty.
          #
          # Note: We're missing a number of actions to produce a better vim experience.
          # This is what is possible today! But we plan on adding more actions to make
          # this even better in the future.

          # Entry point
          "ctrl+b>v=activate_key_table:vim"

          # Key table definition
          "vim/"

          # Line movement
          "vim/j=scroll_page_lines:1"
          "vim/k=scroll_page_lines:-1"

          # Page movement
          "vim/ctrl+d=scroll_page_down"
          "vim/ctrl+u=scroll_page_up"
          "vim/ctrl+f=scroll_page_down"
          "vim/ctrl+b=scroll_page_up"
          "vim/shift+j=scroll_page_down"
          "vim/shift+k=scroll_page_up"

          # Jump to top/bottom
          "vim/g>g=scroll_to_top"
          "vim/shift+g=scroll_to_bottom"

          # Search (if you want vim-style search entry)
          "vim/slash=start_search"
          "vim/n=navigate_search:next"

          # Copy mode / selection
          # Note we're missing a lot of actions here to make this more full featured.
          "vim/v=copy_to_clipboard"
          "vim/y=copy_to_clipboard"

          # Command Palette
          "vim/shift+semicolon=toggle_command_palette"

          # Exit
          "vim/escape=deactivate_key_table"
          "vim/q=deactivate_key_table"
          "vim/i=deactivate_key_table"
          "vim/ctrl+c=deactivate_key_table"

          # Catch unbound keys
          "vim/catch_all=ignore"
        ];
      };
    };
  };
}
