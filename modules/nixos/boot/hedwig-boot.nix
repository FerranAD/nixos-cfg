{ pkgs, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = lib.mkDefault false;
      grub.configurationLimit = 5;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };
}
