{
  projectRootFile = "flake.nix";

  programs.nixfmt.enable = true;
  programs.shfmt.enable = true;
  programs.stylua.enable = true;

  settings.global.excludes = [
    "result/**"
  ];
}
