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
    # ./wifi-passwords.nix

    ../shared/convenient-defaults.nix
    ../shared/wifi-passwords.nix
  ];

  networking.hostName = "owlbear";

  services.hardware.bolt.enable = true;

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

  hardware.intel-gpu-tools.enable = true;

  # virtualisation.vmware.host.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.uartman = {
    isNormalUser = true;
    description = "Anton Gusev";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "kvm"
      "adbusers"
    ];
    packages = with pkgs; [
      thunderbird
      intel-gpu-tools
      # Language servers
      # VS Code
      # vscode-fhs
      # Gaming?
      # Libreoffice

      neovide
      wl-clipboard

      emacs
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    self.inputs.nix-alien.packages.x86_64-linux.nix-alien
    mangohud
    kdePackages.plasma-thunderbolt
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # fontconfig
      # wayland
      # libX11
      (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${steam-run.fhsenv}/usr/lib64 $out/lib")
      mangohud
    ];
  };

  virtualisation.waydroid.enable = true;

  fonts.packages = with pkgs; [
    arkpandora_ttf
  ];

  services.syncthing = {
    user = "uartman";
    dataDir = "/home/uartman/";
    configDir = "/home/uartman/.config/syncthing";
    settings = {
      folders = {
        "Main Obsidian Vault" = {
          path = "/home/uartman/Documents/Obsidian vaults/Main Vault/";
          devices = [
            "uartpc"
            "pixel"
          ];
        };
        "Shared Music" = {
          path = "/home/uartman/Music/Shared/";
          devices = [
            "uartpc"
            "pixel"
          ];
        };
      };
    };
  };

  boot = {
    kernelParams = [
      "i915.enable_psr=1"
      "i915.enable_guc=0"
      "zswap.enabled=1"
    ];
    kernel.sysctl = {
      "dev.i915.perf_stream_paranoid" = 0;
      "vm.swappiness" = 100;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  systemd.oomd = {
    enableRootSlice = true;
    enableUserSlices = true;
  };

  # services.earlyoom.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
