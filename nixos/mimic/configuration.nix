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
    self.inputs.nix-alien.packages.x86_64-linux.nix-alien
    mangohud
    lact
    cemu
    ryubing
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

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/E47221BA7221927A";
    fsType = "ntfs3";
    options = [
      "discard"
      "rw"
      "uid=root"
      "gid=harddrives"
      "users"
      "umask=002"
      "exec"
      "acl"
    ];
  };

  fileSystems."/mnt/harddrive" = {
    device = "/dev/disk/by-uuid/00EC74173638A268";
    fsType = "ntfs3";
    options = [
      "rw"
      "uid=root"
      "gid=harddrives"
      "users"
      "umask=002"
      "exec"
      "acl"
    ];
  };

  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/461C9DF81C9DE36B";
    fsType = "ntfs3";
    options = [
      "discard"
      "rw"
      "uid=root"
      "gid=harddrives"
      "users"
      "umask=002"
      "exec"
      "acl"
    ];
  };

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

  networking.firewall.allowedUDPPorts = [ 27031 27036 10400 10401 ];
  networking.firewall.allowedTCPPorts = [ 27036 27037 ];

  programs.alvr.enable = true;
  programs.alvr.openFirewall = true;
  

  system.stateVersion = "24.05";
}
