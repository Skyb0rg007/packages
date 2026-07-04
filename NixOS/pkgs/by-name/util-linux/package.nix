{
  lib,
  nixpkgs,
  stdenv,
  fetchFromGitHub,
  flex,
  bison,
  gettext,
  asciidoctor,
  libtool,
  automake,
}:
(nixpkgs.util-linux.override {
  translateManpages = false;
}).overrideAttrs
  (
    finalAttrs: prevAttrs: {
      version = "${prevAttrs.version}+securebits";
      src = fetchFromGitHub {
        owner = "Skyb0rg007";
        repo = "util-linux";
        rev = "87397f60013a9bfb4054ae1d673b8f9a0cef6062";
        hash = "sha256-0jc6M0uV9Zq3IrN1Cf/99ksWX/FJrZvNbK0DAkujcVA=";
      };
      patches = [ ];
      preConfigure = "./autogen.sh";
      nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [
        libtool
        automake
        flex
        bison
        gettext
        asciidoctor
      ];
    }
  )
