{config, lib, pkgs, ...}:
  with lib;
{
  imports = [
    ./backend
    ./displayManager
    ./windowManager
    #./stylix.nix
  ];

  options = {
    host.feature.graphics = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enables Graphics Support";
      };
      acceleration = mkOption {
        default = false;
        type = with types; bool;
        description = "Enables graphics acceleration";
      };
      stylix = mkOption {
        default = false;
        type = with types; bool;
        description = "Enables Stylix for uniform color schemes";
      };
      backend = mkOption {
        type = types.enum ["x" "wayland" null];
        default = null;
        description = "Backend of displayManager";
      };
      monitors = mkOption {
        type = with types; listOf str;
        default = [];
        description = "Declare the order of monitors in Window manager configurations";
      };
    };
  };

  config = {
    hardware = {
      ## 24.11 - Rename hardware.opengl. to hardware.graphics.
      opengl = mkIf ((config.host.feature.graphics.enable) && (config.host.feature.graphics.acceleration)) {
        #enable = true;
        #enable32Bit = true;    # 24.11
        driSupport = true;      # 24.11 - Remove in favour of enable
        driSupport32Bit = true; # 24.11 - Remove in favor of enable 32Bit
      };
    };
  };
}
