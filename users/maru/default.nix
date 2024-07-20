{ config, lib, pkgs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
  with lib;
{
  options = {
    host.user.maru = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable Maru";
      };
    };
  };

  config = mkIf config.host.user.maru.enable {
    users.users.maru = {
      isNormalUser = true;
      shell = pkgs.zsh;
      uid = 1337;
      group = "users" ;
      extraGroups = [
        "wheel"
        "video"
        "audio"
      ] ++ ifTheyExist [
        "adbusers"
        "deluge"
        "dialout"
        "docker"
        "git"
        "input"
        "libvirtd"
        "lp"
        "mysql"
        "network"
        "podman"
      ];

      openssh.authorizedKeys.keys = [ (builtins.readFile ./ssh.pub) ];
      #hashedPasswordFile = mkDefault config.sops.secrets.maru-password.path;
      password = "temporalpass";
    };

    sops.secrets.maru-password = {
      sopsFile = mkDefault ../secrets.yaml;
      neededForUsers = mkDefault true;
    };
  };
}
