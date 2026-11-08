{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
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

    rubar = {
      url = "github:yutadev31/rubar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cpst = {
      url = "github:yutadev31/cpst/v0.1.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    shot = {
      url = "github:yutadev31/shot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wt = {
      url = "github:yutadev31/wt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      prefix = "nix/";
    };
}
