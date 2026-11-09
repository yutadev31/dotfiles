{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    codex
    bubblewrap
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr
  ];

  home.file.".codex/AGENTS.md".source = ./AGENTS.md;
}
