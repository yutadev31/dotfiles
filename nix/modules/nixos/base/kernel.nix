{ pkgs, ... }:
{
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;

    "kernel.yama.ptrace_scope" = 1;

    "kernel.unprivileged_bpf_disabled" = 1;
  };
}
