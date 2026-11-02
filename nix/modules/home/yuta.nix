{ flake, ... }:
let
  username = "yuta";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    flake.homeModules.common
    flake.homeModules.cli
  ];

  home = {
    inherit username homeDirectory;
  };
}
