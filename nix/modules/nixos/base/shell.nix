{ pkgs, ... }:
{
  programs.fish.enable = true;
  users.users.yuta.shell = pkgs.fish;
}
