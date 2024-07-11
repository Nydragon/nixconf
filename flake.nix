{
  description = "Nydragon's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./hosts ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          inputs',
          config,
          pkgs,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              pre-commit
              nixfmt-rfc-style
              nodePackages.prettier
              typos
            ];
            shellHook = ''
              ${pkgs.pre-commit}/bin/pre-commit install -f
            '';
          };
        };

      flake = rec {
        templates = import ./templates;
        # TODO: move that somewhere else
        lib = inputs.nixpkgs.lib.extend (
          self: super: {
            my = import ./lib {
              lib = self;
              inherit inputs;
            };
          }
        );
      };
    };
}
