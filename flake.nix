{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-alien,
      lanzaboote,
      nur,
      sops-nix,
      ...
    }@attrs:
    {
      nixosConfigurations.owlbear = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          nur.modules.nixos.default
          lanzaboote.nixosModules.lanzaboote
          sops-nix.nixosModules.sops
          ./nixos/owlbear/configuration.nix
        ];
      };

      formatter."x86_64-linux" = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
