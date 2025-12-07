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
      pkgsi686Linux.xorg.libXcursor
      pkgsi686Linux.xorg.libXcomposite
      pkgsi686Linux.xorg.libXi
      pkgsi686Linux.xorg.libXrandr
      # pkgsi686Linux.xorg
    ];
  };
}
