{
  lib,
  fetchFromGitLab,
  stdenvNoCC,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "debian-archive-keyring";
  version = "2025.1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "release-team";
    repo = "debian-archive-keyring";
    rev = "2025.1";
    hash = "sha256-NaVbca1mx0j4hfSncX8hh8PbtB92yGeZUUdp4Nx9JoY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/etc/apt/trusted.gpg.d apt-trusted-asc/*.asc

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GnuPG archive keys of the Debian archive";
    homepage = "https://salsa.debian.org/release-team/debian-archive-keyring";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
