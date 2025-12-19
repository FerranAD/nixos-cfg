{ pkgs, ... }:
{
  nix.settings.extra-sandbox-paths = [ "/run/binfmt" ];
  # TODO: Checkout wtf is this and other qemu options which may not be needed
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    binfmt.preferStaticEmulators = true;
    binfmt.registrations.aarch64-linux = {
      interpreter = "${pkgs.qemu-user}/bin/qemu-aarch64";
      fixBinary = true;
      wrapInterpreterInShell = false;
    };

    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.dbus.enable = true;
      systemd.emergencyAccess = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth.enable = true;
    kernelParams = [
      "nvidia-drm.fbdev=1"
      "nvidia-drm.modeset=1"
      "ec_sys.write_support=1"
      "nowatchdog"
      "audit=0"
      "modprobe.blacklist=sp5100_tco"
      "loglevel=3"
      "reboot=bios"
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "vt.global_cursor_default=0"
    ];
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };
}
