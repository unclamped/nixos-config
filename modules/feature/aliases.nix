{ lib }:

let
  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ...";
    home = "cd ~";
    fuck = "sudo $(history -p !!)";
    mkdir = "mkdir -p";
    scstart = "systemctl start $@";
    scstop = "systemctl stop $@";
    scenable = "systemctl enable $@";
    scdisable = "systemctl disable $@";
  };
in
{
  shellAliases = shellAliases;
}