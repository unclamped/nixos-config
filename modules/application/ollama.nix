{config, lib, pkgs, ...}:

let
  cfg = config.host.application.ollama;
in
  with lib;
{
  options = {
    host.application.ollama = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enables ollama";
      };
    };
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = mkIf (device.gpu == "nvidia" || device.gpu == "hybrid-nvidia")  { "cuda" };
    };
  };
}