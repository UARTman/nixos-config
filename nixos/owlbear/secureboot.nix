{
  pkgs,
  lib,
  ...
}:

{
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = true;

  boot.plymouth.enable = true;

  environment.systemPackages = with pkgs; [
    sbctl
    tpm2-tss
  ];
}
