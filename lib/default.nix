{ lib, inputs, ... }:
{

  # Verify the existence of a binary inside of a derivation.
  # Returns the path to the binary or throws.
  checkPath =
    pkg: bin:
    let
      abs = lib.getExe' pkg bin;
    in
    if builtins.pathExists abs then abs else throw "${abs} does not exist.";

  mkSystem =
    {
      hostname,
      extraModules ? [ ],
      system,
    }:
    lib.nixosSystem {
      inherit system;
      modules = [
        ../hosts/${hostname}/configuration.nix
        { networking.hostName = hostname; }
      ] ++ extraModules;
      specialArgs = {
        inherit inputs;
        username = "nico";
      };
    };
}
