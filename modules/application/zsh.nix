{config, lib, pkgs, ...}:
let
  cfg = config.host.application.zsh;
  
  aliasesModule = import ../feature/aliases.nix { inherit lib; };
  shellAliases = aliasesModule.shellAliases;
in
  with lib;
{
  options = {
    host.application.zsh = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enables zsh";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zsh # zsh shell
    ];

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        inherit shellAliases;
        shellInit = ''
              setopt INC_APPEND_HISTORY     # Append to history instead of overwriting
              setopt SHARE_HISTORY          # Share history lines across sessions
              setopt HIST_EXPIRE_DUPS_FIRST # Remove duplicates at end of session
              setopt HIST_IGNORE_ALL_DUPS    # Ignore duplicate lines
              setopt HIST_FIND_NO_DUPS      # Don't find duplicates in history
              setopt HIST_REDUCE_BLANKS     # Reduce blanks in history lines
              setopt HIST_SAVE_NO_DUPS      # Save lines to history even if they match an existing line
              setopt HIST_VERIFY             # Require confirmation before saving history
              setopt HIST_IGNORE_SPACE       # Ignore commands starting with a space
              setopt HIST_IGNORE_DUPS        # Ignore duplicate commands
              setopt HIST_IGNORE_SUBSTR      # Ignore commands containing certain substrings
              setopt HIST_IGNORE_CASE        # Ignore case when comparing history lines
              setopt HIST_IGNORE_MOTD        # Ignore the message-of-the-day
              setopt HIST_IGNORE_PATTERNS="ls:ll:ls -alh:pwd:clear:history:ps" # Ignore specific commands

              # Conditional aliases based on command availability
              if command -v nmcli > /dev/null; then
                  alias wifi_scan="nmcli device wifi rescan && nmcli device wifi list"
              fi

              if command -v curl > /dev/null; then
                  alias derp="curl https://cht.sh/\$1"
              fi

              if command -v grep > /dev/null; then
                  alias grep="grep --color=auto"
              fi

              if command -v netstat > /dev/null; then
                  alias ports="netstat -tulanp"
              fi

              if command -v tree > /dev/null; then
                  alias tree="tree -Cs"
              fi

              if command -v rsync > /dev/null; then
                  alias rsync="rsync -aXxtv"
              fi

              # Function for rg, fzf, bat integration
              if command -v rg > /dev/null && command -v fzf > /dev/null && command -v bat > /dev/null; then
                  function frg {
                      result=$(rg --ignore-case --color=always --line-number --no-heading "$@" |
                          fzf --ansi \
                              --color 'hl:-1:underline,hl+:-1:underline:reverse' \
                              --delimiter ':' \
                              --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
                              --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
                      file="''${result%%:*}"
                      linenumber="''${result\#*:}"
                      if [[ -n "$file" ]]; then
                          $EDITOR +"''${linenumber}" "$file"
                      fi
                  }
              fi

              # Custom function
              pkgrun() {
                  if [[ -n $1 ]]; then
                      local pkg="$1"
                      if [[ "$2" != "" ]]; then
                          shift
                          local args="$@"
                      else
                          args="$pkg"
                      fi
                      nix-shell -p $pkg.out --run "$args"
                  fi
              }
        '';
      };
    };
  };
}
