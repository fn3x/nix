{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ../../home/common.nix
    ../../home/shell
    ../../home/neovim
    ../../home/ghostty
    ../../home/hypr
    ../../home/river
    ../../home/tmux
    ../../home/wofi
    ../../home/vicinae
    ../../home/browsers
    ../../home/sneemok
    ../../home/caelestia
    ../../home/dankmaterial
    ../../home/games
    ../../home/niri
    ../../home/noctalia
    ../../home/television
    ../../home/audio
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    inputs.spotifast.packages.${pkgs.stdenv.hostPlatform.system}.default
    (symlinkJoin {
      name = "mattermost-desktop-wrapped";
      paths = [ mattermost-desktop ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/mattermost-desktop \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}
      '';
    })
    wofi
    logmein-hamachi
    r2modman
    whitesur-kde
    poop
    rustdesk-flutter
    gajim
    filezilla
    signal-desktop
    freerdp
    protontricks
    cpupower-gui
    jujutsu
    stremio-linux-shell
    tigervnc
    audacity4
    claude-code
    hyphanet
    usbtree
    reaper
    kdePackages.elisa
  ];

  fish.enable = true;
  neovim.enable = true;
  hyprland.enable = true;
  hyprpanel.enable = false;
  caelestia.enable = false;
  dankmaterial.enable = false;
  vicinae.enable = true;
  ghostty.enable = true;
  nu.enable = false;
  brave.enable = true;
  helium.enable = true;
  sneemok.enable = false;
  shadps4.enable = false;
  bblauncher.enable = false;
  prismlauncher.enable = true;
  lutris.enable = true;
  niri.enable = true;
  noctalia.enable = true;
  television.enable = true;

  # Only non-default values; see the winapps README for all keys.
  # The password lives outside the repo: echo -n '...' > ~/.config/winapps/rdp-pass
  xdg.configFile."winapps/winapps.conf".text = ''
    RDP_USER="art"
    RDP_PASS="$(cat "$HOME/.config/winapps/rdp-pass")"
    RDP_IP="192.168.122.173"
    VM_NAME="RDPWindows"
    WAFLAVOR="libvirt"
    RDP_SCALE="100"
    REMOVABLE_MEDIA="/run/media"
    RDP_FLAGS="/cert:tofu /sound /microphone +home-drive"
    DEBUG="true"
    VIRSH_CONNECTION="qemu:///system"
  '';

  # Browser defaults come from home/browsers, folders from home/common.nix
  xdg.mimeApps = {
    defaultApplications = {
      "application/pdf" = [ "helium.desktop" ];
      "image/png" = [ "helium.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ];
      "video/vnd.radgamettools.bink" = [ "vlc.desktop" ];
      "audio/vnd.wave" = [ "org.kde.elisa.desktop" ];
      "x-scheme-handler/web+nzp" = [ "helium.desktop" ];
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      "x-scheme-handler/postman" = [ "postman.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
    };
    associations.added = {
      "application/pdf" = [ "helium.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
        "writer.desktop"
        "helium.desktop"
      ];
      "image/png" = [ "helium.desktop" ];
      "video/vnd.radgamettools.bink" = [ "vlc.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      "audio/vnd.wave" = [ "org.kde.elisa.desktop" ];
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
