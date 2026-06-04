{
  description = "Nix packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      git-hooks,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      systems = lib.systems.flakeExposed;
      forAllSystems = lib.genAttrs systems;
      pkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      checks = forAllSystems (system: {
        pre-commit-check = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            editorconfig-checker.enable = true;
          };
        };
      });
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
            nativeBuildInputs = [
              pkgs.git
              pkgs.nix
              pkgs.nix-update
            ];
            env.NIX_CONFIG = "extra-experimental-features = nix-command flakes";
          };
        }
      );
      formatter = forAllSystems (system: pkgsFor.${system}.nixfmt-tree);
      legacyPackages = forAllSystems (
        system:
        import ./default.nix {
          pkgs = pkgsFor.${system};
        }
      );
      packages = forAllSystems (
        system: lib.filterAttrs (_: v: lib.isDerivation v) self.legacyPackages.${system}
      );
      hydraJobs = {
        inherit (self.packages) "x86_64-linux";
      };
      nixosModules = import ./modules;
    };
}
