{config, lib, pkgs, ...}:

let
  cfg = config.host.feature.virtualization.distrobox;
in
  with lib;
{
  options = {
    host.feature.virtualization.distrobox = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enables Distrobox";
      };
    };
  };

  config = mkIf (cfg.enable) {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.systemPackages = [ pkgs.distrobox ];
  };
}
