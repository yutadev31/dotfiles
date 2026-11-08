{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    codex
    bubblewrap
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr
  ];
}
