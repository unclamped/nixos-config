{config, lib, pkgs, ...}:

let
  cfg = config.host.application.diceware;
in
  with lib;
{
  options = {
    host.application.diceware = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enables diceware";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      diceware
    ];

    programs = {
      bash = {
        shellInit = ''
          ## Password Generation
          pwgen() {
              if [ -n "$1" ] ; then pwords=$1 ; else pwords=4 ; fi
              unset genpassword
              counter=1
              for s_password in ''$(eval echo "{1..$pwords}") ; do
              case $counter in
                  "2" | "4" | "6" | "8" | "10" | "12" | "14" | "16" )
                      s_password=$(diceware -n 1)
                      s_password=''${s_password^^}
                  ;;
                  "1" | "3" | "5" | "7" | "9" | "11" | "13" | "15" )
                      s_password=$(diceware -n 1 --no-caps)
                      s_password=''${s_password,,}
                  ;;
              esac

              if [ "$counter" -lt $pwords ] ; then
                 s_password="$s_password-"
              fi

              genpassword=$genpassword$s_password
              (( counter+=1 ))

              done

              echo $genpassword
              unset genpassword
          }
        '';
      };
      zsh = {
        shellInit = ''
          pwgen() {
            local pwords=''${1:-4} # Default to 4 if no argument is passed
            local genpassword=()
            local counter=1

            for _ in ''${(seq 1 $pwords)}; do
                local s_password
                case $counter in
                    (2|4|6|8|10|12|14|16)
                        s_password=$(diceware -n 1)
                        s_password=''${s_password^^}
                        ;;
                    (1|3|5|7|9|11|13|15)
                        s_password=$(diceware -n 1 --no-caps)
                        s_password=''${s_password,,}
                        ;;
                esac

                if [[ $counter -lt $pwords ]]; then
                    s_password+="-"
                fi

                genpassword+=($s_password) # Add to array instead of concatenation
                ((counter++))
            done

            echo "''${genpassword[*]}" # Print the entire array as a space-separated string
            }
        '';
      };
    };
  };
}