{
  pkgs,
  ...
}:

pkgs.stdenv.mkDerivation {
  pname = "whitesur-firefox";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "fn3x";
    repo = "WhiteSur-firefox-theme";
    rev = "563c8998dff1d509a83ea1cbcf13ed4a62a7fdee";
    hash = "sha256-Pk67HiUJR3kjKbtTc4amQM6j6LRciFkXawToR1rPn/o";
  };

  # Make sure the script is executable
  nativeBuildInputs = [ pkgs.coreutils ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Monterey/parts
    mkdir -p $out/Monterey/icons
    mkdir -p $out/Monterey/titlebuttons
    mkdir -p $out/Monterey/pages

    cp -rf $src/src/Monterey $out
    cp -rf $src/src/customChrome.css $out
    cp -rf $src/src/common/{icons,titlebuttons,pages} $out/Monterey
    cp -rf $src/src/common/*.css $out/Monterey
    cp -rf $src/src/common/parts/*.css $out/Monterey/parts
    cp -rf $src/src/userContent-Monterey.css $out/userContent.css
    cp -rf $src/src/userChrome-Monterey-alt.css $out/userChrome.css
    cp -rf $src/src/WhiteSur/parts/headerbar-urlbar.css $out/Monterey/parts/headerbar-urlbar-alt.css

    runHook postInstall
  '';

  meta = {
    description = "MacOS BigSur like firefox theme";
    homepage = "https://github.com/fn3x/WhiteSur-firefox-theme";
  };
}
