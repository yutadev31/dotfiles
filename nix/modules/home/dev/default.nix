{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt
    codex
  ];
}
