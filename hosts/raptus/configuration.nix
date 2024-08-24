{
  modulesPath,
  lib,
  pkgs,
  ...
}:
let
  sshAccess = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvPqWPXEUOSMGMIRmirQfbrzq//NkPlEI2TmFpIkSfw" # brontes
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwlScEmVbdc0EH93XLX+K8yP5FKUKzMf/bWTSO+rMiO" # marr
  ];
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./container-root.nix
    ./rustypaste
    ./forgejo
    ./obsidian-livesync
    ../../modules/nix
  ];

  age.secrets = {
    couchdb.file = ../../secrets/couchdb.age;
    rustypaste.file = ../../secrets/rustypaste.age;
  };

  device.type = {
    vm.enable = true;
    server.enable = true;
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.firewall = lib.mkForce {
    enable = true;
    allowedTCPPorts = [
      22
      443
      5984 # couchdb
      3000 # forgejo
    ];
  };

  # User account to run remote builds
  users.users.remote-build = {
    isSystemUser = true;
    hashedPassword = ""; # Only allow login via ssh
    openssh.authorizedKeys.keys = sshAccess;
    shell = pkgs.bash;
    group = "remote-build";
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;

  users.groups.remote-build = { };

  # Ensure the user can build derivations
  nix.settings.trusted-users = [ "remote-build" ];

  security.acme.defaults.email = "admin@ccnlc.eu";
  security.acme.acceptTerms = true;

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "50M";
    virtualHosts =
      let
        mkVHost = name: port: {
          inherit name;
          value = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString port}";
              extraConfig = ''
                proxy_ssl_server_name on;
                proxy_pass_header Authorization;'';
            };
          };
        };
      in
      builtins.listToAttrs [
        (mkVHost "rusty.ccnlc.eu" 8000)
        (mkVHost "git.ccnlc.eu" 3000)
      ];
  };

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = sshAccess;

  system.stateVersion = "24.11";
}
