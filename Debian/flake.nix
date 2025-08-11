{
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.permittedInsecurePackages = [
          "checkinstall-1.6.2"
        ];
      };
    in {
      packages.pwngrid = pkgs.callPackage ./pwngrid.nix {};
    });
}
