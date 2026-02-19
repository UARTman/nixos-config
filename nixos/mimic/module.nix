{
  pkgs,
  lib,
  config,
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.mimic = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = with inputs; [
      determinate.nixosModules.default
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
      nix-index-database.nixosModules.nix-index
      ./configuration.nix
    ];
  };

}
