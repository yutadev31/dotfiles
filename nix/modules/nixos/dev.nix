{ pkgs, ... }: {
  # User Groups
  users.users.yuta.extraGroups = [
    "adbusers"
    "docker"
  ];

  # Android
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
  ];

  # Docker
  virtualisation.docker = {
    enable = true;
    extraPackages = [ pkgs.docker-compose ];
  };

  # Ollama
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
  };
}
