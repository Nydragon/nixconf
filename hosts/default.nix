{ inputs, ... }:
let
  inherit (inputs.self) lib;
in
{
  flake.nixosConfigurations = {
    marr = lib.my.mkSystem {
      hostname = "marr";
      system = "x86_64-linux";
      extraModules = [
        #inputs.nixos-hardware.nixosModules.dell-xps-15-9510-nvidia
      ];
    };

    brontes = lib.my.mkSystem {
      hostname = "brontes";
      system = "x86_64-linux";
      extraModules = [ inputs.agenix.nixosModules.default ];
    };

    styrak = lib.my.mkSystem {
      hostname = "styrak";
      system = "x86_64-linux";
      extraModules = [ inputs.disko.nixosModules.disko ];
    };
  };
}
