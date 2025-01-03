{ config, pkgs, ... }:

let
  whitesurfox = pkgs.fetchFromGitHub {
    owner = "fn3x";
    repo = "WhiteSur-firefox-theme";
    rev = "563c8998dff1d509a83ea1cbcf13ed4a62a7fdee";
    hash = "sha256-Pk67HiUJR3kjKbtTc4amQM6j6LRciFkXawToR1rPn/o";
  };
in
pkgs.stdenv.mkDerivation rec {
  pname = "whitesur-firefox";
  version = "1.0";

  src = whitesurfox;

  # Make sure the script is executable
  nativeBuildInputs = [ pkgs.coreutils ];

  buildPhase = ''
    chmod +x ${src}/install.sh

    ${src}/install.sh -A
  '';

  installPhase = ''
    firefoxChromeDir="${config.home.homeDirectory}/.mozilla/firefox/default/chrome"
    mkdir -p $firefoxChromeDir

    # Copy files from repo to chrome folder
    cp -r ${src}/src/* $firefoxChromeDir/
  '';
}
