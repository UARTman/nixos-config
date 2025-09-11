{
  self,
  config,
  pkgs,
  system,
  lib,
  ...
}:

{
  imports = [
    ../shared/convenient-defaults.nix
  ];

  networking.hostName = "mimic";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.uartman = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };

  system.stateVersion = "24.05";
}