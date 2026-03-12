
{
  pkgs,
  ...
}:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Catppuccin Mocha Dark";
    size = 22;
    package = pkgs.catppuccin-cursors.mochaDark;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Catppuccin Mocha Dark";
    XCURSOR_SIZE = 22;
  };
}
