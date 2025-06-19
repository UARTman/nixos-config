{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./steam.nix
    ./idris2.nix
    ./neovim.nix
    ./syncthing.nix
  ];

  config = {

    environment = {
      systemPackages = with pkgs; [
        git
        lazygit

        direnv
        killall

        vlc
        libvlc

        obsidian
        obsidian-export

        hunspell
        hunspellDicts.ru_RU
        hunspellDicts.en_US-large

        gnupg
      ];
      variables = {
        SUDO_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
      };
    };

    services = {
      fwupd.enable = true;

      # Network discovery
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
          hinfo = true;
          userServices = true;
          workstation = true;
        };
      };

      # Enable the X11 windowing system.
      # You can disable this if you're only using the Wayland session.
      xserver.enable = true;

      # Enable the KDE Plasma Desktop Environment.
      displayManager.sddm = {
        enable = true;
        theme = "breeze";
      };

      desktopManager.plasma6.enable = true;

      # Configure keymap in X11
      xserver.xkb = {
        layout = "us,ru";
        options = "grp:caps_toggle";
      };

      # Enable CUPS to print documents.
      printing.enable = true;

      printing.drivers = with pkgs; [
        gutenprint # Drivers for many different printers from many different vendors.
        gutenprintBin # Additional, binary-only drivers for some printers.
        hplip # Drivers for HP printers.
        hplipWithPlugin # Drivers for HP printers, with the proprietary plugin. Use NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup' to add the printer, regular CUPS UI doesn't seem to work.
        postscript-lexmark # Postscript drivers for Lexmark
        samsung-unified-linux-driver # Proprietary Samsung Drivers
        splix # Drivers for printers supporting SPL (Samsung Printer Language).
        brlaser # Drivers for some Brother printers
        brgenml1lpr
        brgenml1cupswrapper # Generic drivers for more Brother printers [1]
        cnijfilter2 # Drivers for some Canon Pixma devices (Proprietary driver)
        epson-escpr2 # Drivers for Epson AirPrint devices
        epson-escpr # Drivers for some other Epson devices
        cups-kyocera-3500-4500 # ISP RAS Kyocera printer
      ];

      samba.enable = true;

      # Enable sound with pipewire.
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      };

      fail2ban.enable = true;
      openssh = {
        enable = true;
        ports = [ 22 ];
        settings = {
          PasswordAuthentication = false;
          AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
          UseDns = true;
          X11Forwarding = true;
          PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
        };
      };

      # YubiKey support
      pcscd.enable = true;

      zerotierone = {
        enable = true;
        joinNetworks = [
          "1d71939404bd0816"
        ];
      };

      syncthing.settings.devices = {
        "uartpc" = {
          id = "CY5YEK2-BCLLIQI-2S7RDTQ-5UTH7TW-OSH57RK-HZ46Q5D-ANJD4RI-B24PKAY";
        };
        "pixel" = {
          id = "YOABTVV-RXHTLM2-SVLE6OG-DXOYLFE-ZQ7LVGR-3SCXZDF-D7EUTKZ-2PHQ3QI";
        };
        "owlbear" = {
          id = "2HPWTOS-4CFTD67-5FBDEDY-36LHYLC-E7NN3SL-2EH5TRP-5M6V6JA-ZOO5BAW";
        };
      };

    };

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Moscow";

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = "ru_RU.UTF-8";
        LC_IDENTIFICATION = "ru_RU.UTF-8";
        LC_MEASUREMENT = "ru_RU.UTF-8";
        LC_MONETARY = "ru_RU.UTF-8";
        LC_NAME = "ru_RU.UTF-8";
        LC_NUMERIC = "ru_RU.UTF-8";
        LC_PAPER = "ru_RU.UTF-8";
        LC_TELEPHONE = "ru_RU.UTF-8";
        LC_TIME = "ru_RU.UTF-8";
      };
    };

    programs = {
      fzf = {
        keybindings = true;
        # fuzzyCompletion = true;
      };
      firefox.enable = true;

      # Breeze-dark in gtk
      dconf.enable = true;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      bash.shellAliases = {
        snrf = "sudo nixos-rebuild --flake .#${config.networking.hostName}";
        switch-to-configuration = "/run/current-system/bin/switch-to-configuration";
        nix-regen-boot = "sudo /run/current-system/bin/switch-to-configuration boot";
        hmf = "home-manager --flake .#$HOSTNAME-$USER";
      };

      tmux = {
        enable = true;
        terminal = "tmux-direct";
      };

      nekoray = {
        enable = true;
        tunMode.enable = true;
      };

    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    # Allow flakes
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    virtualisation.docker.enable = true;

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      enableRedistributableFirmware = true;

      # Enable bluetooth
      bluetooth.enable = true;

    };

    fonts.packages = with pkgs; [
      nerd-fonts.iosevka
      iosevka
    ];

    # For pipewire, TODO refactor
    security.rtkit.enable = true;

  };
}
