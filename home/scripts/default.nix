{ pkgs, ... }:
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

  set-background = pkgs.writers.writeFishBin "set-background" (
    builtins.readFile (
      pkgs.fetchurl {
        url = "https://codeberg.org/Nydragon/scripts/raw/commit/bb7a40545fa5cfce177cdac009d9f46f4823d360/set_background.fish";
        hash = "sha256-Qoz5nn0tqV6QtsXv9fsOkf3PafL30iO/eIkh8ro6O+c=";
      }
    )
  );

  nixedit = pkgs.writers.writeFishBin "nixedit" "env --chdir ~/.nixconf $EDITOR .";

  getext = pkgs.writeScriptBin "ls | grep -E \"\.[a-zA-Z0-9]+$\" --only-matching  | sort | uniq";
}
