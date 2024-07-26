{config, lib, pkgs, ...}:
let
  cfg = config.host.feature.graphics.stylix;
in
  with lib;
{
  options = {
    host.feature.graphics.stylix = {
      autoLogin = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Automatically log a user into a session";
        };
    };
  };

  config = mkIf ((config.host.feature.graphics.stylix)) {
    stylix.enable = true;
    host.feature.graphics.displayManager.session = mkIf (config.host.feature.home-manager.enable) [
        {
          name = "home-manager";
          start = ''
              ${pkgs.runtimeShell} $HOME/.hm-xsession &
              waitPID=$!
          '';
        }
      ];
  };
}
