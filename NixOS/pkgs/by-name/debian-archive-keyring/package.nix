{
  lib,
  fetchFromGitLab,
  stdenvNoCC,
  nix-update-script,
  jetring,
  gnupg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "debian-archive-keyring";
  version = "2025.1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "release-team";
    repo = "debian-archive-keyring";
    tag = finalAttrs.version;
    hash = "sha256-NaVbca1mx0j4hfSncX8hh8PbtB92yGeZUUdp4Nx9JoY=";
  };

  makeFlags = [ "DESTDIR=$(out)" ];

  nativeBuildInputs = [
    jetring
    gnupg
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GnuPG archive keys of the Debian archive";
    homepage = "https://salsa.debian.org/release-team/debian-archive-keyring";
    license = [
      lib.licenses.gpl2Plus
      lib.licenses.publicDomain
    ];
    platforms = lib.platforms.all;
    badPlatforms = [ "x86_64-freebsd" ];
  };
})
