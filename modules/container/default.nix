{lib, ...}:

with lib;
{
  imports = [
    ./clamav.nix
    #./fluentbit.nix
    #./llng-handler.nix
    #./postfix-relay.nix
    #./restic.nix
    ./socket-proxy.nix
    #./tinc.nix
    ./unbound.nix
    ./zabbix.nix
  ];
}