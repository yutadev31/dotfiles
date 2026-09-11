{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-voicevox.url = "github:NixOS/nixpkgs/24e8d730ef4adac7727652e666cbf9dce4d21d03";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-voicevox,
      home-manager,
      rust-overlay,
      nixvim,
      treefmt-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
      pkgs-voicevox = import nixpkgs-voicevox {
        inherit system;
        config.allowUnfree = true;
      };
      hostNames = [
        "laptop2"
      ];
      mkConfigurations = builder: lib.genAttrs hostNames (hostName: builder hostName);
      buildHomeConfiguration =
        hostName:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            inherit hostName;
            inherit pkgs-voicevox;
          };
          modules = [
            (./. + "/hosts/${hostName}/home.nix")
            nixvim.homeModules.nixvim
          ];
        };

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";

        programs.nixfmt.enable = true;
        programs.shfmt.enable = true;
        programs.stylua.enable = true;

        settings.global.excludes = [
          "result/**"
        ];
      };
    in
    {
      nixosConfigurations = mkConfigurations (
        hostName: nixpkgs.lib.nixosSystem { modules = [ (./. + "/hosts/${hostName}") ]; }
      );

      homeConfigurations = mkConfigurations buildHomeConfiguration;

      formatter.${system} = treefmtEval.config.build.wrapper;

      checks.${system}.formatting = treefmtEval.config.build.check self;
    };
}
