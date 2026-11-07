{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    codex
    bubblewrap
    inputs.wt.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr
  ];
}
