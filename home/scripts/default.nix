{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.writers) writeFishBin;
  nixos-rebuild =
    name: word:
    writeFishBin name ''
      env --chdir ~/.nixconf ${pkgs.nh}/bin/nh os ${word} . $argv \
        && ${lib.my.checkPath pkgs.libnotify "notify-send"} nixos-rebuild "Rebuild complete" \
            -a nixos-rebuild \
            -i ${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg
    '';
in
{
  screenshot =
    with pkgs;
    writeShellApplication {
      name = "screenshot";
      runtimeInputs = [
        slurp
        wl-clipboard
        libnotify
      ];
      text = ''
        location="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d-%H%M%S)-screenshot.png";

        if zone=$(slurp); then
        grim -t png -g "$zone" - | wl-copy --type image/png && wl-paste > "$location" \
        && notify-send --app-name Screenshot -i "$location" --urgency=low "Screenshot copied to clipboard" "Screenshot created at $location";
        fi
      '';
    };

  set-background = writeFishBin "set-background" ''
    argparse 'f/file=!test -e "$_flag_value"' -- $argv; or return

    set pids $(pidof swaybg)

    if set -q _flag_file
      ${pkgs.swaybg}/bin/swaybg -i "$(find $_flag_file | shuf -n 1)" > /dev/null 2>&1 &
    else
      ${pkgs.swaybg}/bin/swaybg -i "$(find ~/Pictures/backgrounds | shuf -n 1)" > /dev/null 2>&1 &
    end

    sleep 0.5;

    for i in $(string split " " $pids)
      echo "killing process $i";
      kill -9 "$i";
    end
  '';

  nixedit = writeFishBin "nixedit" "env --chdir ~/.nixconf $EDITOR .";

  getext = pkgs.writeScriptBin "ls | grep -E \"\.[a-zA-Z0-9]+$\" --only-matching  | sort | uniq";

  rpaste = writeFishBin "rpaste" ''
    export $(cat ${config.age.secrets.rustypaste.path} | xargs)
    ${pkgs.rustypaste-cli}/bin/rpaste -a "$AUTH_TOKEN" -s "https://rusty.ccnlc.eu/" $argv
  '';

  gentest = nixos-rebuild "gentest" "test";

  genswitch = nixos-rebuild "genswitch" "switch";

  fishl = writeFishBin "fishl" ./logo.fish;

  nrun = writeFishBin "nrun" ''
    if echo "$argv[1]" | grep -Eq '^[a-z]+:.+/.+$'
        nix run $argv[1] -- $argv[2..]
    else
        nix run nixpkgs#$argv[1] -- $argv[2..]
    end
  '';

  editsym = writeFishBin "editsym" ''
    for file in $argv
        cp "$file" "$file.tmp"
        unlink "$file"
        mv "$file.tmp" "$file"
        chmod -R 777 "$file"
    end
  '';
}
