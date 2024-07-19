{ config, inputs, pkgs, ...}: {

  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ../common
  ];

  boot = {
    kernelParams = [
      "video=HDMI-1:1366x768@75"
    ];
  };

  host = {
    feature = {
      appimage.enable = true;
      gaming = {
        gamemode.enable = true;
        gamescope.enable = false;
        heroic.enable = false;
        steam = {
          enable = true;
          protonGE = true;
        };
      };
      graphics = {
        enable = true;
        backend = "wayland";
        displayManager.manager = "sddm";
        windowManager.manager = "hyprland";
      };
      virtualization = {
        flatpak.enable = true;
        waydroid.enable = true;
      };
    };
    filesystem = {
      btrfs.enable = true;
      impermanence.enable = true;
      encryption.enable = true;
      ntfs.enable = true;
      swap = {
        partition = "disk/by-uuid/0839e935-d57b-4384-9d48-f557d0250ec1"; # TODO Change this once I know my swap uuid
      };
      tmp.tmpfs.enable = true;
    };
    hardware = {
      cpu = "intel";
      gpu = "nvidia";
      keyboard.enable = true;
      sound = {
        server = "pipewire";
      };
    };
    network = {
      hostname = "turing";
    };
    role = "desktop";
    host.feature.development.crosscompilation = false;
    bluetooth.enable = false;
    wireless.enable = false;
    user = {
      maru.enable = true;
      root.enable = true;
    };
  };
}
