{ pkgs, ... }:

{
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamescope
      jq
      cabextract
      wget
      git
      pkgsi686Linux.libpulseaudio
      pkgsi686Linux.freetype
      pkgsi686Linux.libxcursor
      pkgsi686Linux.libxcomposite
      pkgsi686Linux.libxi
      pkgsi686Linux.libxrandr
      # pkgsi686Linux.xorg
    ];
  };
}
