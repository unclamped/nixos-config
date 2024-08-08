{config, lib, pkgs, ...}:

let
  cfg = config.host.feature.keeblayout;
in
  with lib;
{
  options = {
    host.feature.keeblayout = {
      layout = mkOption {
        default = "us";
        type = with types; str;
        description = "Set keyboard layout";
      };
      variant = mkOption {
        default = "";
        type = with types; str;
        description = "Set keyboard variant";
      };
    };
  };

  config = {
    services.xserver.xkb = {
      layout = cfg.layout;
      variant = cfg.variant;
    };

    # `keymap` won't apply when prompted to enter the passphrase to decrypt on boot
    console = {
      earlySetup = true;
      useXkbConfig = true;
    };
  };
}