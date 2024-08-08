{ inputs, ... }:
let
  inherit (inputs.self) lib;
in
{
  flake.nixosConfigurations = {
    marr = lib.my.mkSystem {
      hostname = "marr";
      system = "x86_64-linux";
    };

    brontes = lib.my.mkSystem {
      hostname = "brontes";
      system = "x86_64-linux";
      extraModules = [
        {
          nix.settings = {
            substituters = [ "https://cosmic.cachix.org/" ];
            trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          };
        }
        inputs.nixos-cosmic.nixosModules.default
      ];
    };

    styrak = lib.my.mkSystem {
      hostname = "styrak";
      system = "x86_64-linux";
      extraModules = [ inputs.disko.nixosModules.disko ];
    };
  };
}
