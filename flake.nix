{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    split-monitor-workspaces = {
      url = "github:zjeffer/split-monitor-workspaces";
      flake = false;
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    rudesktop = {
      url = "github:yutadev31/rudesktop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
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
          };
          modules = [
            (./. + "/nix/hosts/${hostName}/home.nix")
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

      devPackages = with pkgs; [
        bash-language-server
        lua-language-server
        vscode-langservers-extracted
        tombi
        nixd
        nixfmt
        typos-lsp
        shfmt
        stylua
      ];
    in
    {
      nixosConfigurations = mkConfigurations (
        hostName: nixpkgs.lib.nixosSystem { modules = [ (./. + "/nix/hosts/${hostName}") ]; }
      );

      homeConfigurations = mkConfigurations buildHomeConfiguration;

      formatter.${system} = treefmtEval.config.build.wrapper;

      checks.${system}.formatting = treefmtEval.config.build.check self;

      devShells.${system}.default = pkgs.mkShell {
        packages = devPackages;
      };
    };
}
