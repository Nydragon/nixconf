{ pkgs, ... }:
{
  home.packages = [ pkgs.lollypop ];

  dconf.settings = {
    "org/gnome/Lollypop" = {
      network-access = true;
      artist-artwork = true;
      dark-ui = true;
      import-advanced-artist-tags = true;
      force-single-column = false;
      show-compilations-in-album-view = true;
      show-compilations = false;
      hd-artwork = true;
      shown-playlists = [
        (-3)
        (-7)
      ];
    };
  };
}
