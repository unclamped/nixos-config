{ config, inputs, pkgs, ...}: {

  imports = [
    inputs.disko.nixosModules.disko
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
      development = {
        crosscompilation = false;
      };
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
        partition = "disk/by-uuid/d7ad2715-9ba7-4ba6-b8ce-f006f8fee66b";
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
    hardware.bluetooth.enable = false;
    hardware.wireless.enable = false;
    user = {
      maru.enable = true;
      root.enable = true;
    };
  };
}
