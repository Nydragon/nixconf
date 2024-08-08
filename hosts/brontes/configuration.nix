# vim:fileencoding=utf-8:foldmethod=marker
{
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../../modules
    ./home.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;
  services.flatpak.enable = true;

  #: Power Consumption {{{
  services.logind = {
    powerKey = "hibernate";
  };
  #: }}}

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  services.dbus.enable = true;
  services.desktopManager.cosmic.enable = true;
  programs = {
    dconf.enable = true;
    steam.enable = true;
    fish.enable = true;
    firefox.enable = true;
    thunderbird.enable = true;
    hyprland.enable = true;
  };

  security.polkit.enable = true;
  users = {
    defaultUserShell = pkgs.fish;
    users.${username} = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "libvirtd" # VM OPs
        "dialout" # Necessary for serial port interactions
      ];
      shell = pkgs.fish;
    };
  };

  # Necessary for Nautilus to display trash, DVDs and for gnome-disk-utility to show file systems
  services.gvfs.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    fish
    wireguard-tools
    git
    htop
    eza
    bat
    swaynotificationcenter
  ];

  system.stateVersion = "24.05";
}
