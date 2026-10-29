{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ripgrep
    nixd
    nixfmt
    lua-language-server
    websocat
    tree-sitter
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
