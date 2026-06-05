{
  lib,
  stdenv,
  fetchFromGitLab,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ascsaver";
  version = "1.0.8.11";

  src = fetchFromGitLab {
    owner = "mezantrop";
    repo = "ascsaver";
    rev = "cba337b5a73659c182f7e0c4ba71156f3594125a";
    hash = "sha256-D/bvkQ9s18sxnmzqxn4H5RHVe0UVFiVXhOJsnSJ9Rh0=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
    command = "ascsaver";
  };

  meta = {
    description = "Screensaver for terminals";
    homepage = "https://gitlab.com/mezantrop/ascsaver";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
