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
      allSystems = lib.systems.flakeExposed;
      defaultSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = lib.genAttrs allSystems;
      forDefaultSystems = lib.genAttrs defaultSystems;
      pkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      checks = forDefaultSystems (system: {
        pre-commit-check = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            editorconfig-checker.enable = true;
          };
        };
      });
      devShells = forDefaultSystems (
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
      formatter = forDefaultSystems (system: pkgsFor.${system}.nixfmt-tree);
      legacyPackages = forAllSystems (
        system:
        import ./default.nix {
          pkgs = pkgsFor.${system};
        }
      );
      packages = forAllSystems (
        system:
        let
          hostPlatform = pkgsFor.${system}.stdenv.hostPlatform;
          isBuildable =
            v: lib.isDerivation v && !(v.meta.broken or false) && lib.meta.availableOn hostPlatform v;
        in
        lib.filterAttrs (_: isBuildable) self.legacyPackages.${system}
      );
      hydraJobs = {
        inherit (self.packages) "x86_64-linux";
      };
      nixosModules = import ./modules/nixos;
    };
}
