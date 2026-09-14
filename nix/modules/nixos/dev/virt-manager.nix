{
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  users.users.yuta.extraGroups = [
    "libvirtd"
    "kvm"
  ];
}
