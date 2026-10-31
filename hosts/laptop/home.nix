{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../home/common.nix
    ../../home/neovim
    ../../home/ghostty
    ../../home/hypr
    ../../home/wofi
    ../../home/vicinae
    ../../home/shell
    ../../home/browsers
    ../../home/sneemok
    ../../home/caelestia
    ../../home/noctalia
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # keep pre-26.05 behaviour: gtk4 apps follow gtk.theme
  gtk.gtk4.theme = config.gtk.theme;

  home.packages = with pkgs; [
    mattermost-desktop
    cantarell-fonts
    anydesk
  ];

  neovim.enable = true;
  hyprland.enable = true;
  vicinae.enable = true;
  ghostty.enable = true;
  fish.enable = true;
  brave.enable = true;
  noctalia.enable = true;
}
