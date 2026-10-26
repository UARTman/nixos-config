{ pkgs, ... }:
{
  nixpkgs.overlays = [ (final: prev: {
    inherit (prev.lixPackageSets.lix_2_96)
      nixos-anywhere
      nil
      # nix-direnv
      nix-du
      nix-update
      nix-init
      nurl
      nixpkgs-review
      nix-eval-jobs
      nix-fast-build
      colmena;
  })];

  nix.package = pkgs.lixPackageSets.lix_2_96.lix;
}
