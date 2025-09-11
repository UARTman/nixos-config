{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    # obsidian-nvim.url = "github:epwalsh/obsidian.nvim";
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
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      lanzaboote,
      nur,
      sops-nix,
      nvf,
      rust-overlay,
      ...
    }@inputs:
    {
      nixosConfigurations.owlbear = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          (
            { ... }:
            {
              nixpkgs.overlays = [
                rust-overlay.overlays.default
              ];
            }
          )
          nur.modules.nixos.default
          lanzaboote.nixosModules.lanzaboote
          sops-nix.nixosModules.sops
          nvf.nixosModules.default
          ./nixos/owlbear/configuration.nix
        ];
      };
      
      nixosConfigurations.mimic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          (
            { ... }:
            {
              nixpkgs.overlays = [
                rust-overlay.overlays.default
              ];
            }
          )
          nur.modules.nixos.default
          lanzaboote.nixosModules.lanzaboote
          sops-nix.nixosModules.sops
          nvf.nixosModules.default
          ./nixos/mimic/configuration.nix
        ];
      };

      homeConfigurations.owlbear-uartman = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          nvf.homeManagerModules.default
          ./home-manager/owlbear-uartman/home.nix
        ];
      };

      formatter."x86_64-linux" = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
