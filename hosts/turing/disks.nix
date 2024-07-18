{
  imports = [ ./disko-config.nix ];
  disko.devices.disk.main.device = "/dev/nvme0n1";
}
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "EFI";
              name = "ESP";
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              label = "swap";
              size = "8G"; # SWAP - Do not Delete this comment
              content = {
                type = "swap";
                randomEncryption = true;
                resumeDevice = true;
              };
            };
            luks = {
              label = "encrypted" ;
              size = "100%";
              content = {
                type = "luks";
                name = "pool0_0";
                extraOpenArgs = [ "--allow-discards" ];
                # if you want to use the key for interactive login be sure there is no trailing newline
                # for example use `echo -n "password" > /tmp/secret.key`
                passwordFile = "/tmp/secret.key"; # Interactive. Write to this file the encryption passphrase
                # or file based
                # settings.keyFile = "/tmp/secret.key";
                # additionalKeyFiles = ["/tmp/additionalSecret.key"];

                # These settings are pretty extreme, schizo-level. Thank god I'm not a criminal,
                # but if you are, you might benefit from these configs :)
                # For legal reasons, that was a joke. Don't do crime.
                # extraFormatArgs = [
                #   "--cipher serpent-xts-plain64"
                #   "--key-size 512"
                #   "--iter-time 10000"
                #   #"--hash whirlpool"
                # ]; 
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/root-blank" = {
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/home" = {
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/home/active" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/home/snapshots" = {
                      mountpoint = "/home/.snapshots";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/persist" = {
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/persist/active" = {
                      mountpoint = "/persist";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/persist/snapshots" = {
                      mountpoint = "/persist/.snapshots";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/var_local" = {
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/var_local/active" = {
                      mountpoint = "/var/local";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/var_local/snapshots" = {
                      mountpoint = "/var/local/.snapshots";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/var_log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
