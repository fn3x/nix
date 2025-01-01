{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "berkeley";
  version = "2.0";

  src = ../../../fonts/berkeley.zip;

  unpackPhase = ''
    runHook preUnpack
    ${pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 berkeley/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
