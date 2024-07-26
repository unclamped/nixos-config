{config, lib, pkgs, ...}:

let
  cfg = config.host.application.mullvad;
in
  with lib;
{
  options = {
    host.application.mullvad = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enables mullvad";
      };
    };
  };

  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;

    services.mullvad-vpn.package = pkgs.mullvad-vpn;
  };
}