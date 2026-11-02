{ pkgs, ... }: {
  # System
  system.stateVersion = "25.05";

  # Nix
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Nixpkgs
  nixpkgs.config.allowUnfree = true;

  # Nix ld
  programs.nix-ld.enable = true;

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "jp106";
  time.timeZone = "Asia/Tokyo";

  # Sudo
  security.sudo.enable = true;

  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Shell
  programs.fish.enable = true;

  # User
  users.users = {
    yuta = {
      shell = pkgs.fish;
      isNormalUser = true;
      description = "Yuta";
      extraGroups = [
        "wheel"
        "kvm"
      ];
    };
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.defaultGateway = "192.168.11.1";

  # DHCP
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  # DNS
  networking.networkmanager.dns = "none";
  networking.resolvconf.enable = false;
  networking.nameservers = [
    "1.1.1.2"
    "1.0.0.2"
  ];
  services.resolved.enable = false;

  # Firewall
  networking.firewall.allowedTCPPorts = [
    22
  ];

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "yuta" ];
    };
  };
}
