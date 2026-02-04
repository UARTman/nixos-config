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
    ../shared/convenient-defaults.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mimic";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.uartman = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "kvm"
      "adbusers"
      "harddrives"
    ];
  };

  users.users.artem = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "kvm"
      "adbusers"
      "harddrives"
    ];
  };

  users.groups.harddrives = {
    name = "harddrives";
  };

  time.hardwareClockInLocalTime = true;

  environment.systemPackages = with pkgs; [
    lact
    cemu
    ryubing
    beyond-all-reason
    (prismlauncher.override {
      additionalPrograms = with pkgs; [
        ffmpeg
      ];

      additionalLibs = with pkgs; [
        (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${steam-run.fhsenv}/usr/lib64 $out/lib")
      ];
    })
    gamescope
    ntfs3g
  ];

  fonts.packages = with pkgs; [
    arkpandora_ttf
    corefonts
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

  systemd.oomd = {
    enableRootSlice = true;
    enableUserSlices = true;
  };

  fileSystems = {
    "/mnt/harddrive" = {
      device = "/dev/disk/by-uuid/6efbfb86-97f7-45f2-8b06-a3c4c10ad36e";
      fsType = "ext4";
    };

    "/mnt/ssd" = {
      device = "/dev/disk/by-uuid/ceff12d1-5af9-40de-9772-1e555fdcbe8c";
      fsType = "ext4";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  xdg = {
    # enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [ "kde" ];
      };
    };
  };

  systemd.services.lactd = {
    enable = true;
    description = "LACT Daemon";
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
      ExecStop = "pkill lact";
      Restart = "on-failure";
      RestartSec = 5;
    };
    wantedBy = [ "default.target" ];
  };

  networking.firewall.allowedUDPPorts = [
    27031
    27036
    10400
    10401
  ];
  networking.firewall.allowedTCPPorts = [
    27036
    27037
  ];

  programs.alvr.enable = true;
  programs.alvr.openFirewall = true;

  system.stateVersion = "24.05";
}
