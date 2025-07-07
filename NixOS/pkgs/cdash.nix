{
  pkgs,
  cmake,
  php,
  nodejs,
  fetchFromGitHub,
  fetchNpmDeps,
  ...
}: let
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "CDash";
    rev = "v${version}";
    hash = "sha256-ftJuEF7tALxw/k3JF5c0suS7TeC5tsrivkUYA6V9SX4=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-VLXLF/RDdbX4f2yvXXGsRckFkBdPUSQN3+iOIPdJNJM=";
  };
in
  php.buildComposerProject2 (finalAttrs: {
    pname = "cdash";
    inherit version src;

    npmDeps = npmDeps;

    php = php.buildEnv {
      extensions = {
        enabled,
        all,
      }:
        enabled
        ++ [
          all.bcmath
          all.curl
          all.fileinfo
          all.mbstring
          all.pdo
          all.posix
          all.simplexml
          all.xsl
          all.zlib
        ];
    };

    vendorHash = "sha256-FL0Z2642d272QgKXpQnreJEjodeIg7VTPR2VqwO+KNY=";
  })
# pkgs.stdenv.mkDerivation {
# inherit pname version;
# buildInputs = [
#   cmake
#   php
#   nodejs
# ];
# }

