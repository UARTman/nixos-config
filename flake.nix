{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-alien, lanzaboote, ... }@attrs : {
    nixosConfigurations.owlbear = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        lanzaboote.nixosModules.lanzaboote
        ./nixos/owlbear/configuration.nix
      ];
    };
  };
}
