{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blueprint = {
      url = "github:numtide/blueprint";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";
    split-monitor-workspaces = {
      url = "github:zjeffer/split-monitor-workspaces";
      flake = false;
    };

    rubar.url = "github:yutadev31/rubar/v0.1.0";
    cpst.url = "github:yutadev31/cpst/v0.1.1";
    shot.url = "github:yutadev31/shot/v0.1.0";
  };

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      prefix = "nix/";
    };
}
