{ pkgs, ... }:
let
  patchelf = pkgs.patchelf.overrideAttrs {
    version = "0.19.3";
    src = pkgs.fetchurl {
      url = "https://github.com/NixOS/patchelf/releases/download/0.19.3/patchelf-0.19.3.tar.bz2";
      hash = "sha256-INviPp28StdpB4qGetACwEKXoGn/k8lftyJC3VXU3W8=";
    };
  };
in
{
  services.trilium-server = {
    enable = true;
    dataDir = "/data/trilium";
    port = 8083;
    package = pkgs.trilium-server.overrideAttrs (old: {
      version = "0.106.1";
      src = pkgs.fetchurl {
        url = "https://github.com/TriliumNext/Trilium/releases/download/v0.106.1/TriliumNotes-Server-v0.106.1-linux-x64.tar.xz";
        hash = "sha256-WbWR275Cizo4pJPYlUuwOE8RjFyT5F2b/YuJJwwo1iA=";
      };
      # shortcut: use patched Patchelf for Trilium until nixpkgs ships 0.19.3.
      preFixup = (old.preFixup or "") + ''
        export PATH="${patchelf}/bin:$PATH"
      '';
    });
  };
}
