{config, lib, ...}:
with lib;
{
  imports = [
    ./distrobox.nix
    ./docker.nix
    ./flatpak.nix
    ./virtd.nix
    ./waydroid.nix
  ];
}