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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-7adaa102-d438-4e9e-9972-4a3c91b887b3".device = "/dev/disk/by-uuid/7adaa102-d438-4e9e-9972-4a3c91b887b3";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  hardware.graphics.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1200
  '';

  programs = {
    dconf.enable = true;
    steam.enable = true;
    fish.enable = true;
    firefox.enable = true;
    thunderbird.enable = true;
    sway.enable = true;
  };

  #: Virtualisation {{{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  #: }}}

  #: Power Consumption {{{

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    powerKey = "hibernate";
  };

  services.thermald.enable = true;

  services.tlp = {
    enable = false;
    settings = {
      #        CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      #        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      #        CPU_MIN_PERF_ON_AC = 0;
      #       CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";
  };
  #:}}}

  services.fwupd.enable = true;

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr = {
      settings = {
        screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
      enable = true;
    };
    config.common.default = "*";
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gvfs.enable = true;

  # Configure console keymap
  console.keyMap = "fr";

  users = {
    defaultUserShell = pkgs.fish;
    users.${username} = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "libvirtd"
        "dialout" # Necessary for serial port interactions
      ];
      shell = pkgs.fish;
    };
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.sway}/bin/sway";
        user = "${username}";
      };
      default_session = initial_session;
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.flatpak.enable = true;

  environment.variables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    MOZ_ENABLE_WAYLAND = 1;
  };

  security.polkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    shared-mime-info
    fish
    nextcloud-client
    git
    firefox
    htop
    alacritty
    eza
    bat
    kdeconnect
    glib
    wireguard-tools
    dconf
    pavucontrol
    xdg-utils
    brightnessctl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
