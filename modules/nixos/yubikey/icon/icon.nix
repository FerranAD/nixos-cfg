{
  stdenv,
  imagemagick,
}:

let
  icon = ./yubikey-touch-detector.svg;
  icon-name = "yubikey-touch-detector";
in

stdenv.mkDerivation {
  name = "yubikey-touch-detector-icon";
  pname = "yubikey-touch-detector-icon";
  version = "0.1";

  src = null;

  unpackPhase = "true";

  nativeBuildInputs = [
    imagemagick
  ];

  postInstall = ''
    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      convert -background none -resize ''${i}x''${i} ${icon} $out/share/icons/hicolor/''${i}x''${i}/apps/${icon-name}.png
    done
  '';
}
