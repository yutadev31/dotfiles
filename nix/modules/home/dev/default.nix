{ inputs, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      nixd
      nixfmt
      typos
      typos-lsp
      inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
      codex
    ]
    ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      orca
      chatgpt
    ]);
}
