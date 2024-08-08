{
  pkgs,
  lib,
  osConfig,
  ...
}:
lib.mkIf osConfig.programs.firefox.enable {
  programs.firefox = {
    enable = true;
    # Installed by nixpkgs module
    package = null;
    profiles.nico = {
      name = "Nico";
      isDefault = true;
      search = {
        default = "DuckDuckGo";
        force = true;
        engines =
          let
            nixicon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            iconUpdateInterval = 24 * 60 * 60 * 1000; # every day
          in
          {
            "NixOS Packages" = {
              urls = [ { template = "https://search.nixos.org/packages?query={searchTerms}"; } ];
              icon = nixicon;
              definedAliases = [
                "@nixpkg"
                "@nixpkgs"
              ];
            };
            "NixOS Wiki" = {
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              icon = nixicon;
              definedAliases = [ "@nixwiki" ];
            };
            "NixOS Options" = {
              urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
              icon = nixicon;
              definedAliases = [ "@nixoptions" ];
            };
            "Arch Wiki" = {
              urls = [
                { template = "https://wiki.archlinux.org/index.php?title=Special:Search&search={searchTerms}"; }
              ];
              iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
              updateInterval = iconUpdateInterval;
              definedAliases = [ "@archwiki" ];
            };
            "DuckDuckGo" = {
              urls = [ { template = "https://duckduckgo.com/?q={searchTerms}"; } ];
              iconUpdateURL = "https://duckduckgo.com/favicon.ico";
              updateInterval = iconUpdateInterval;
              definedAliases = [
                "@duckduckgo"
                "@ddg"
              ];
            };
            "MyNixOS" = {
              urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
              iconUpdateURL = "https://mynixos.com/favicon.ico";
              updateInterval = iconUpdateInterval;
              definedAliases = [
                "@hm"
                "@mynixos"
              ];
            };
            "stackoverflow" = {
              urls = [ { template = "https://stackoverflow.com/search?q={searchTerms}"; } ];
              iconUpdateURL = "https://cdn.sstatic.net/Sites/stackoverflow/Img/favicon.ico";
              updateInterval = iconUpdateInterval;
              definedAliases = [ "@stackoverflow" ];
            };

            Noogle = {
              urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
              icon = nixicon;
              definedAliases = [
                "@noogle"
                "@ngl"
              ];
            };
          };
      };
    };
  };
}
