{ config, lib, modulesPath, pkgs, ... }:
let
  role = config.host.role;
in
  with lib;
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = mkIf (role == "minimal") {
    host = {
      feature = {
        boot = {
          efi.enable = mkDefault false;
          graphical.enable = mkDefault false;
        };
        graphics = {
          enable = mkDefault false;
          acceleration = mkDefault true;
        };
      };
      filesystem = {
        btrfs.enable = mkDefault false;
        encryption.enable = mkDefault false;
        impermanence = {
          enable = mkDefault false;
          directories = [
            "/mnt/"
          ];
        };
      };
      hardware = {
        bluetooth.enable = mkDefault false;
        printing.enable = mkDefault false;
        raid.enable = mkDefault false;
        sound.enable = mkDefault false;
        webcam.enable = mkDefault false;
        wireless.enable = mkDefault false;
        yubikey.enable = mkDefault false;
      };
    };
  };
}