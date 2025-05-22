{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ripgrep
    nixd
    nixfmt-rfc-style
    lua-language-server
    websocat
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
