{
  username,
  pkgs,
  config,
  ...
}:
{
  home-manager.users.${username} = {
    imports = [
      ../../home/sway
      ../../home/rofi
      ../../home/themes/catppuccin.nix
      ../../home
    ];

    dconf = {
      enable = true;
      settings."org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };

    services.blueman-applet.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home = {
      stateVersion = config.system.stateVersion;
      inherit username;

      packages = with pkgs; [
        digikam
        fragments
        element-desktop
        libreoffice
        loupe
        seahorse
        gimp
        vlc
        thunderbird
        keepassxc
        nautilus
        protonmail-bridge-gui
        varia
        signal-desktop
        calibre

        # Proprietary
        postman
        mongodb-compass
        obsidian

        # CLI tools
        delta
        fzf
        jhead
        fdupes
        exiftool
        sshfs
        zip
        unzip
        lazygit
        fd
        ripgrep
        swaybg
        wl-clipboard

        custom.scripts.screenshot
        custom.scripts.nixedit
        custom.scripts.set-background
      ];
    };
  };
}
