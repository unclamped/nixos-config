{config, lib, pkgs, ...}:
  with lib;
{
  imports = [
    ./gpu/amd.nix
    ./gpu/intel.nix
    ./gpu/nvidia.nix
  ];

  options = {
    host.hardware.gpu = mkOption {
        type = types.enum [ "amd" "intel" "nvidia" "hybrid-nv" "hybrid-amd" "integrated-amd" "pi" null];
        default = null;
        description = "Manufacturer/type of the primary system GPU";
    };
  };
}