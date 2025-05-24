# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
    ./hardware-configuration.nix
    ./fedora.nix
    ./secureboot.nix
    ./sops.nix

    ../shared/convenient-defaults.nix
  ];

  networking.hostName = "owlbear";

  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 Synaptics TrackPoint";
  };

  hardware.graphics = {
    extraPackages = with pkgs; [
      vpl-gpu-rt
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
      intel-vaapi-driver
      intel-compute-runtime
      intel-media-driver
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.uartman = {
    isNormalUser = true;
    description = "Anton Gusev";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
      telegram-desktop
      zotero-beta
      vesktop
      yubioath-flutter
      kitty
      qbittorrent
      tor-browser
      intel-gpu-tools
      # Language servers
      tinymist
      typst
      # VS Code
      vscode-fhs
      # Gaming?
      lutris
      xivlauncher
      # Libreoffice
      libreoffice-qt6-fresh

      neovide
      wl-clipboard

      gnumake

      emacs
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nekoray
    tun2proxy
    lazygit
    vlc
    libvlc

    hunspell
    hunspellDicts.ru_RU
    hunspellDicts.en_US-large

    self.inputs.nix-alien.packages.x86_64-linux.nix-alien

    gnupg
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # fontconfig
    # wayland
    # libX11
    (pkgs.runCommand "steamrun-lib" { }
      "mkdir $out; ln -s ${steam-run.fhsenv}/usr/lib64 $out/lib"
    )
  ];

  virtualisation.waydroid.enable = true;

  fonts.packages = with pkgs; [
    arkpandora_ttf
  ];

  networking.firewall.trustedInterfaces = [ "tun0" ];
  networking.firewall.checkReversePath = "loose";

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "1d71939404bd0816"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
