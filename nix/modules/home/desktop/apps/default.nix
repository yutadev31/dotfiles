{ pkgs, inputs, ... }: {
  imports = [
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    slack
    nautilus
    loupe
    vscode
    obsidian
    gimp
    inkscape
    blockbench
    blender
    audacity
    vlc
    prismlauncher

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt
  ];

  programs.google-chrome.enable = true;

  services.syncthing.enable = true;
}
