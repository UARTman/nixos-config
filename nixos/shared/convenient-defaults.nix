{
  pkgs,
  lib,
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

    environment.systemPackages = with pkgs; [
      git
      direnv
      killall

      kdePackages.yakuake
    ];

    services.fwupd.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;

    # Enable networking
    networking.networkmanager.enable = true;

    # Network discovery
    services.avahi = {
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

    # Set your time zone.
    time.timeZone = "Europe/Moscow";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
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

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    services.displayManager.sddm.theme = "breeze";

    environment.variables.SUDO_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us,ru";
      options = "grp:caps_toggle";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    services.printing.drivers = with pkgs; [
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

    services.samba.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
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

    programs.fzf = {
      keybindings = true;
      # fuzzyCompletion = true;
    };

    programs.firefox.enable = true;

    # Breeze-dark in gtk
    programs.dconf.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    # Allow flakes
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    fonts.packages = with pkgs; [
      nerd-fonts.iosevka
      iosevka
    ];

    services.fail2ban.enable = true;
    services.openssh = {
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

    services.pcscd.enable = true;

    virtualisation.docker.enable = true;

    programs.bash.shellAliases = {
      snrf = "sudo nixos-rebuild --flake .#${config.networking.hostName}";
      switch-to-configuration = "/run/current-system/bin/switch-to-configuration";
      nix-regen-boot = "sudo /run/current-system/bin/switch-to-configuration boot";
    };

    programs.tmux.enable = true;
    programs.tmux.terminal = "tmux-direct";

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
