{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ripgrep
    nixd
    nixfmt
    lua-language-server
    websocat
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
