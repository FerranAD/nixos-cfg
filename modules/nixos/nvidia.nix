{
  pkgs,
  config,
  lib,
  ...
}:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  environment.systemPackages = [ nvidia-offload ];

  boot.blacklistedKernelModules = [ "nouveau" ];
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

  programs.gpu-screen-recorder.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
      ];
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        sync.enable = true;
        # offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
