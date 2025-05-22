{
  pkgs,
  ...
}:

{
  config = {
    environment.systemPackages = with pkgs; [
      git
      idris2
      idris2Packages.pack
      chez
      rlwrap
      gnumake
    ];
  };
}
