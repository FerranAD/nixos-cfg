{
  inputs,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x50014ee20b75cc2f";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF02";
            };

            swap = {
              size = "2G";
              content = {
                type = "swap";
                resumeDevice = false;
              };
            };

            primary = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
