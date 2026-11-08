{
  lib,
  hyprlandPlugins,
  cmake,
  nlohmann_json,
  src,
}:

# Pinned for Hyprland 0.55.4; update the source alongside the compositor.
hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hymission";
  version = "0.4.2";
  inherit src;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ nlohmann_json ];
  doCheck = true;

  meta = {
    description = "Mission Control-style overview for Hyprland";
    homepage = "https://github.com/gfhdhytghd/hymission";
    license = lib.licenses.gpl3Only;
  };
}
