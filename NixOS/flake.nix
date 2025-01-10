{
  description = "Nix packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    git-hooks,
    ...
  } @ inputs: let
    systems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgsFor = forAllSystems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    checks = forAllSystems (system: {
      pre-commit-check = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          editorconfig-checker.enable = true;
        };
      };
    });
    devShells = forAllSystems (system: let
      pkgs = pkgsFor.${system};
    in {
      default = pkgs.mkShellNoCC {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        nativeBuildInputs = [
          pkgs.git
          pkgs.nix
        ];
        env.NIX_CONFIG = "extra-experimental-features = nix-command flakes";
      };
    });
    formatter = forAllSystems (system: pkgsFor.${system}.alejandra);
    packages = forAllSystems (system: import ./pkgs {pkgs = pkgsFor.${system};});
    overlays.default = final: prev: import ./pkgs {pkgs = final.pkgs;};
  };
}
