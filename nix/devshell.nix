{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [
    nixd
    nixfmt
    typos-lsp
    bash-language-server
    lua-language-server
    vscode-langservers-extracted
    tombi
    shfmt
    stylua
  ];
}
