{ config, outputs, lib, pkgs, ... }:
  with lib;
{
  imports = [
    ./locale.nix
    ./nix.nix
    ../../users
  ] ++ (builtins.attrValues outputs.nixosModules);

  boot = {
    initrd = {
      compressor = mkDefault "zstd";
      compressorArgs = mkDefault ["-19"];

      systemd = {
        strip = mkDefault true;                         # Saves considerable space in initrd
      };
    };
    kernel.sysctl = {
      "vm.dirty_ratio" = mkDefault 6;                   # sync disk when buffer reach 6% of memory
    };
    kernelPackages = pkgs.linuxPackages_zen;            # Zen kernel
  };

  environment = {
    defaultPackages = [];                               # Don't install any default programs, force everything
    enableAllTerminfo = mkDefault false;
  };

  hardware.enableRedistributableFirmware = mkDefault true;

  host = {
    application = {
      bash.enable = mkDefault true;
      zsh.enable = mkDefault true;
      bind.enable = mkDefault true; # Bind keys to custom events. Personal TODO
      binutils.enable = mkDefault true;
      coreutils.enable = mkDefault true;
      curl.enable = mkDefault true;
      diceware.enable = mkDefault true; # Passphrase gen. I need to stop depending on Bitwarden a bit. Personal TODO
      dust.enable = mkDefault true; # Like gdu, I should research this a bit more. Personal TODO
      # e2fsprogs.enable = mkDefault true; # ext2/3/4 utils including e2fsck. I don't really use ext4 in any of these machines, so, nah
      fzf.enable = mkDefault true; # File searcher, tbh a great tool. Personal TODO
      git.enable = mkDefault true;
      htop.enable = mkDefault true;
      iftop.enable = mkDefault true; # Top for network. Personal TODO
      inetutils.enable = mkDefault true; # ftp, ping, telnet, tftp, etc
      iotop.enable = mkDefault true; # Top for disk ops. Personal TODO
      kitty.enable = mkDefault true;
      less.enable = mkDefault true; # Nano but read-only. Personal TODO
      links.enable = mkDefault true; # Terminal web browser, Useful, Personal TODO. Alternatives are w3m, Lynx, and the most promising is browsh. TODO on researching browsh
      lsof.enable = mkDefault true; # Lists open files. Useful tool, Personal TODO
      mtr.enable = mkDefault true; # Debug traceroute to a host. Useful tool, Personal TODO
      nano.enable = mkDefault true;
      gdu.enable = mkDefault true;
      pciutils.enable = mkDefault true;
      psmisc.enable = mkDefault true; # fuser, killall, pstree. Useful tools. Personal TODO
      rsync.enable = mkDefault true; # Personal TODO, rsync is beautiful, gotta master it
      strace.enable = mkDefault true;  # strace shows syscalls by processes. Interesting tool, Personal TODO
      tmux.enable = mkDefault true; # Personal TODO Learn how to use tmux
      wget.enable = mkDefault true;
    };
    feature = {
      home-manager.enable = mkDefault true;
      # secrets.enable = mkDefault true;
    };
    # Commenting this out because my net does not have a domain name besides what comes
    # from my ISP. Could I consider this as a Personal TODO if I want to migrate to maru.olcese.com.ar
    # in the future?
    # network = {
    #   domainname = mkDefault "tiredofit.ca";
    # };
    service = {
      logrotate = {
        enable = mkDefault true;
      };
      ssh = {
        enable = mkDefault true;
        harden = mkDefault true;
      };
    };
  };

  security = {
    pam.loginLimits = [
      # Increase open file limit for sudoers
      # Maru's note here, I'm not exactly sure how exactly this is benefitial, but
      # I'll keep it here since it doesn't seem to bring anything negative
      {
        domain = "@wheel";
        item = "nofile";
        type = "soft";
        value = "524288";
      }
      {
        domain = "@wheel";
        item = "nofile";
        type = "hard";
        value = "1048576";
      }
    ];
    sudo.wheelNeedsPassword = mkDefault false;
  };

  services.fstrim.enable = mkDefault true; # Useful for SSDs
  users.mutableUsers = mkDefault false;
}
