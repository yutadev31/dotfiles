{ flake, ... }:
let
  username = "root";
  homeDirectory = "/root";
in
{
  imports = [
    flake.homeModules.common
  ];

  home = {
    inherit username homeDirectory;
  };
}
