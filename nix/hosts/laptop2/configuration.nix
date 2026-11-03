{ pkgs, flake, ... }: {
  imports = [
    ./hardware-configuration.nix
    flake.nixosModules.common
    flake.nixosModules.dev
    flake.nixosModules.desktop
    flake.nixosModules.mcserver
  ];

  # Boot Loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;

    "kernel.yama.ptrace_scope" = 1;

    "kernel.unprivileged_bpf_disabled" = 1;
  };
  boot.kernelParams = [
    "amd_pstate=active"
  ];

  # Networking
  networking.hostName = "laptop2";
  networking.interfaces.enp1s0.ipv4.addresses = [
    {
      address = "192.168.11.100";
      prefixLength = 24;
    }
  ];

  # System
  boot.tmp.useTmpfs = true;

  environment.systemPackages = with pkgs; [
    piper
    libratbag
  ];
  services.ratbagd.enable = true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GiB
    }
  ];
}
