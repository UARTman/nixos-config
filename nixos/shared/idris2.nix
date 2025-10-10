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
      gcc
      chez
      rlwrap
      gnumake
    ];
    environment.variables = {
      C_INCLUDE_PATH = "${pkgs.lib.makeIncludePath [pkgs.gmp]}";
      LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.gmp]}";
    };
  };
}
