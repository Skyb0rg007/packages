{
  lib,
  stdenv,
  fetchFromGitLab,
}:
stdenv.mkDerivation {
  pname = "ascsaver";
  version = "0.0.0-cba337b5";

  src = fetchFromGitLab {
    owner = "mezantrop";
    repo = "ascsaver";
    rev = "cba337b5a73659c182f7e0c4ba71156f3594125a";
    hash = "sha256-D/bvkQ9s18sxnmzqxn4H5RHVe0UVFiVXhOJsnSJ9Rh0=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
}
