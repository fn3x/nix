{
  pkgs,
  lib,
}:

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "firebot";
  version = "5.67.0";

  src = pkgs.fetchurl {
    url = "https://github.com/crowbartools/Firebot/releases/download/v${finalAttrs.version}/firebot-v${finalAttrs.version}-linux-x64.tar.gz";
    hash = "sha256-Hw9egK/WeGROSWyBmigP1Ncs1K74FQDZa3Gy2GIswMM=";
  };

  # Tarball has no top-level directory
  sourceRoot = ".";

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
    asar
  ];

  # Local patch: let commands trigger when the chat message is a Twitch reply.
  # Twitch prefixes replies with "@<parent user> ", which made the trigger miss the start of the message.
  # Only applies to real replies (isReply), so plain mentions are unaffected; args are parsed from the stripped text.
  # Declined upstream as default behavior: https://github.com/crowbartools/Firebot/issues/3592
  postPatch = ''
    asar extract resources/app.asar app-src
    substituteInPlace app-src/build/backend/chat/commands/chat-command-handler.js \
      --replace-fail 'const rawMessage = firebotChatMessage.rawText;' \
        'const rawMessage = firebotChatMessage.isReply ? firebotChatMessage.rawText.replace(/^@\S+\s+/, "") : firebotChatMessage.rawText;'

    # Local patch: "Wait for sound to finish" waits the exact sound length instead of rounding it to whole seconds
    # (a 0.78 s clip waited 1 s, leaving a gap before the next effect; a 1.4 s clip waited 1 s and overlapped it).
    for f in app-src/build/backend/common/handlers/sound-handler.js \
             app-src/build/backend/integrations/builtin/aws/text-to-speech-polly-effect.js; do
      substituteInPlace "$f" \
        --replace-fail 'const durationInMils = (Math.round(duration) || 0) * 1000;' \
          'const durationInMils = Math.round((Number(duration) || 0) * 1000);'
    done
    rm resources/app.asar
    asar pack app-src resources/app.asar
    rm -r app-src
  '';

  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    systemd
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
    libxshmfence
  ];

  runtimeDependencies = with pkgs; [
    (lib.getLib systemd)
    libGL
    libnotify
    libpulseaudio
    pipewire
    wayland
    # dlopened by native modules inside app.asar (firebot-nutjs)
    libx11
    libxtst
    libxinerama
    libpng
    stdenv.cc.cc.lib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/firebot $out/bin
    cp -r . $out/opt/firebot
    rm -f $out/opt/firebot/env-vars

    for size in 16 24 32 48 128 256; do
      install -Dm644 resources/linux/firebotsetup-icon/''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/firebot.png
    done

    makeWrapper "$out/opt/firebot/Firebot v5" $out/bin/firebot \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.runtimeDependencies} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "firebot";
      exec = "firebot %U";
      icon = "firebot";
      desktopName = "Firebot";
      comment = "Powerful all-in-one bot for Twitch streamers";
      categories = [
        "AudioVideo"
        "Network"
      ];
      startupWMClass = "firebotv5";
    })
  ];

  meta = {
    description = "Powerful all-in-one bot for Twitch streamers";
    homepage = "https://firebot.app";
    changelog = "https://github.com/crowbartools/Firebot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "firebot";
    platforms = [ "x86_64-linux" ];
  };
})
