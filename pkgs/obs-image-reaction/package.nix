{
  pkgs,
}:

let
  # 1.4+ uses gs_image_file_ex_* which only exists in OBS >= 33.
  # Bump to 1.4.1+ once nixpkgs ships OBS 33.
  version = "1.3";
in
pkgs.stdenv.mkDerivation {
  pname = "obs-image-reaction";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "scaledteam";
    repo = "obs-image-reaction";
    rev = version;
    hash = "sha256-mC1B8tveHx35pfbAcOlosB8YKaBVg87MjXbr79sf7+k=";
  };

  nativeBuildInputs = [ pkgs.cmake ];
  buildInputs = [ pkgs.obs-studio ];

  meta = {
    description = "OBS image source that reacts to an audio source";
    homepage = "https://github.com/scaledteam/obs-image-reaction";
    license = pkgs.lib.licenses.gpl2Plus;
    platforms = pkgs.lib.platforms.linux;
  };
}
