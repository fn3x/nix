{
  pkgs,
  ...
}:

pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "teamspeak6-client";
  version = "6.0.0-beta3.2";

  src = pkgs.fetchurl {
    url = "https://files.teamspeak-services.com/pre_releases/client/${finalAttrs.version}/teamspeak-client.tar.gz";
    hash = "sha256-sZrYGonBw3BgUSExovs8GW5E54vhr3i/VR9eH9/qjWM=";
  };

  sourceRoot = ".";

  propagatedBuildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups.lib
    dbus
    gcc-unwrapped.lib
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    libpulseaudio
    libxkbcommon
    libgbm
    nss
    pipewire
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXdamage
    xorg.libXfixes
    xorg.libxshmfence
    xorg.libXtst
  ];

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "TeamSpeak";
      exec = "TeamSpeak";
      icon = "teamspeak6-client";
      desktopName = "TeamSpeak";
      comment = "TeamSpeak Voice Communication Client";
      categories = [
        "Audio"
        "AudioVideo"
        "Chat"
        "Network"
      ];
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/teamspeak6-client $out/share/icons/hicolor/64x64/apps/

    cp -a * $out/share/teamspeak6-client
    cp logo-256.png $out/share/icons/hicolor/64x64/apps/teamspeak6-client.png

    makeWrapper $out/share/teamspeak6-client/TeamSpeak $out/bin/TeamSpeak \
      --prefix LD_LIBRARY_PATH : "${
        pkgs.lib.makeLibraryPath [
          pkgs.udev
          pkgs.libGL
          pkgs.libpulseaudio
          pkgs.pipewire
        ]
      }"

    runHook postInstall
  '';

  updateScript = ./update.sh;

  meta = {
    description = "TeamSpeak voice communication tool (beta version)";
    homepage = "https://teamspeak.com/";
    license = pkgs.lib.licenses.teamspeak;
    mainProgram = "TeamSpeak";
    maintainers = with pkgs.lib.maintainers; [
      gepbird
      jojosch
    ];
    platforms = [ "x86_64-linux" ];
  };
})
