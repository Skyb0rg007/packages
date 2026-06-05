{
  lib,
  fetchFromForgejo,
  stdenv,
  installShellFiles,
  perl,
  perlPackages,
  python3,
  makeWrapper,
  dpkg,
  apt,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mmdebstrap";
  version = "1.5.7";

  src = fetchFromForgejo {
    domain = "gitlab.mister-muffin.de";
    owner = "josch";
    repo = "mmdebstrap";
    tag = finalAttrs.version;
    hash = "sha256-P0S2FHKR2gKtj47xyB7wOZZV5K8p9uLGvJ5tlmgCtdc=";
  };

  nativeBuildInputs = [
    installShellFiles
    perl
    makeWrapper
  ];

  buildInputs = [
    perl
    python3
  ];

  buildPhase = ''
    runHook preBuild

    pod2man mmdebstrap > mmdebstrap.1
    pod2man mmdebstrap-autopkgtest-build-qemu > mmdebstrap-autopkgtest-build-qemu.1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv tarfilter mmtarfilter
    installBin mmdebstrap mmtarfilter mmdebstrap-autopkgtest-build-qemu

    mkdir -p $out/lib/apt/solvers
    cp -a proxysolver $out/lib/apt/solvers

    mkdir -p $out/share/mmdebstrap
    cp -a hooks $out/share/mmdebstrap

    mkdir -p $out/libexec/mmdebstrap
    cp -a gpgvnoexpkeysig $out/libexec/mmdebstrap
    cp -a ldconfig.fakechroot $out/libexec/mmdebstrap

    mkdir -p $out/share/perl5
    pushd ${lib.getDev stdenv.cc.libc}/include
    for h in $(cc -M syscall.h sys/ioctl.h 2>/dev/null \
        | grep -oE '[^ \\]+\.h' \
        | grep '^${lib.getDev stdenv.cc.libc}/include/' \
        | sed 's|^${lib.getDev stdenv.cc.libc}/include/||' \
        | sort -u); do
      h2ph -d $out/share/perl5 "$h"
    done
    h2ph -d $out/share/perl5 syscall.h sys/ioctl.h
    popd

    wrapProgram $out/bin/mmdebstrap \
      --prefix PATH : "${lib.getBin dpkg}/bin:${lib.getBin apt}/bin" \
      --prefix PERL5LIB : "$out/share/perl5" \
      --run 'export DPKG_ADMINDIR=$(mktemp -d); touch "$DPKG_ADMINDIR/status"'

    wrapProgram $out/bin/mmdebstrap-autopkgtest-build-qemu \
      --prefix PATH : "${lib.getBin dpkg}/bin"

    installManPage \
      mmdebstrap.1 \
      mmdebstrap-autopkgtest-build-qemu.1

    runHook postInstall
  '';

  meta = {
    description = "";
    homepage = "https://gitlab.mister-muffin.de/josch/mmdebstrap/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "mmdebstrap";
  };
})
