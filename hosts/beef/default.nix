{ config, inputs, pkgs, ...}: {

  imports = [
    inputs.nur.nixosModules.nur
    ./hardware-configuration.nix

    ../common/global

    ../../users/dave
    ../../users/root
  ];

  boot = {
    initrd.luks.devices = {
      "pool0_0" = {
         allowDiscards = true;
         bypassWorkqueues = true;
      };
      "pool0_1" = {
         allowDiscards = true;
         bypassWorkqueues = true;
      };
    };

    kernelParams = [
      "quiet"
      "video=DP-3:2560x1440@120"
      "video=DP-2:2560x1440@120"
      "video=HDMI-1:2560x1440@120"
      "amdgpu.sg_display=0"
    ];
  };

  host = {
    feature = {
      gaming = {
        enable = true;
        steam = {
          enable = true;
          protonGE = true;
        };
      };
      graphics = {
        enable = true;
        backend = "x";
      };
    };
    filesystem = {
      encryption.enable = true;
    };
    hardware = {
      cpu = "amd";
      gpu = "integrated-amd";
      sound = {
        server = "pulseaudio";
      };
    };
    role = "desktop";
  };

  networking = {
    hostName = "beef";
  };
}
