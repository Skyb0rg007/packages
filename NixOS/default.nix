{
  pkgs ? import <nixpkgs> { config.allowUnfree = true; },
  lib ? pkgs.lib,
  ...
}:
let
  nixosModules = import ./modules/nixos;
  nixosTests = import ./tests/all-tests.nix {
    inherit pkgs nixosModules packages;
  };

  pythonOverride =
    interp:
    interp.override {
      packageOverrides =
        pself: _:
        lib.filesystem.packagesFromDirectoryRecursive {
          callPackage = pself.callPackage;
          directory = ./pkgs/python-modules;
        };
    };

  python3 = pythonOverride pkgs.python3;
  python313 = pythonOverride pkgs.python313;
  python314 = pythonOverride pkgs.python314;
  python315 = pythonOverride pkgs.python315;

  python3Packages = python313Packages;
  python313Packages = python313.pkgs;
  python314Packages = python314.pkgs;
  python315Packages = python315.pkgs;

  mkOcamlPackages =
    base:
    let
      merged = base // localOcamlModules;
      localOcamlModules = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (pkgs // packages // merged // { inherit nixosTests; });
        directory = ./pkgs/ocaml-modules;
      };
    in
    merged;

  ocamlPackages = mkOcamlPackages pkgs.ocamlPackages;
  ocamlNg = lib.mapAttrs (
    _: v: if builtins.isAttrs v && v ? buildDunePackage then mkOcamlPackages v else v
  ) pkgs.ocaml-ng;

  tcl9Packages = pkgs.tcl9Packages // tcl9ModulePackages;
  tcl9ModulePackages = lib.filesystem.packagesFromDirectoryRecursive {
    callPackage = lib.callPackageWith (pkgs // packages // tcl9Packages // { inherit nixosTests; });
    directory = ./pkgs/tcl-modules;
  };

  packages =
    lib.filesystem.packagesFromDirectoryRecursive {
      callPackage = lib.callPackageWith (
        pkgs
        // packages
        // {
          inherit
            python3
            python313
            python314
            python315
            python3Packages
            python313Packages
            python314Packages
            python315Packages
            nixosTests
            ocamlPackages
            tcl9Packages
            ;
          "ocaml-ng" = ocamlNg;
          nixpkgs = pkgs;
        }
      );
      directory = ./pkgs/by-name;
    }
    // {
      inherit
        tcl9Packages
        ocamlPackages
        python3Packages
        python313Packages
        python314Packages
        python315Packages
        ;
      "ocaml-ng" = ocamlNg;
    };
in
{
  inherit nixosModules;
}
// packages
