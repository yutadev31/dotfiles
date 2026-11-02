{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [
    bash-language-server
    lua-language-server
    vscode-langservers-extracted
    tombi
    nixd
    nixfmt
    typos-lsp
    shfmt
    stylua
  ];
}
