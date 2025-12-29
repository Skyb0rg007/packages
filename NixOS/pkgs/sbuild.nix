{
  apt,
  autoreconfHook,
  dpkg,
  fetchFromGitLab,
  groff,
  hostname,
  lib,
  makeWrapper,
  perl,
  perlPackages,
  stdenv,
  system-sendmail,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sbuild";
  version = "0.91.5";
  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "sbuild";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-swVDZz7PSTItQbBV7fP+IgV2LpLs8nwCeCHpeZ3dJps=";
  };

  nativeBuildInputs = [
    autoreconfHook
    dpkg
    groff
    perl
    perlPackages.FilesysDf
    makeWrapper
  ];

  postPatch = ''
    substituteInPlace bin/* tools/* \
      --replace /usr/bin/perl ${lib.getExe perl}
    substituteInPlace lib/Buildd.pm \
      --replace-fail /bin/hostname ${lib.getExe hostname}
    substituteInPlace bin/check-old-builds \
      --replace-fail /usr/sbin/sendmail ${lib.getExe system-sendmail}
    substituteInPlace etc/Makefile.am man/Makefile.am \
      --replace-fail PERL5LIB= 'PERL5LIB=$(PERL5LIB):'
  '';

  postInstall = ''
    for h in syscall.h sys/syscall.h asm/unistd.h asm/unistd_32.h asm/unistd_64.h bits/wordsize.h bits/syscall.h; do
      ${lib.getExe' perl "h2ph"} -d . ${stdenv.cc.libc.dev}/include/$h
      mkdir -p $out/share/perl5/$(dirname $h)
      mv .${stdenv.cc.libc.dev}/include/''${h%.h}.ph $out/share/perl5/$(dirname $h)
    done
    mv *.ph $out/share/perl5
    perlPath="$out/share/perl5:${
      perlPackages.makePerlPath [
        dpkg
        perlPackages.ClassDataInheritable
        perlPackages.DevelStackTrace
        perlPackages.ExceptionClass
        perlPackages.FilesysDf
        perlPackages.MIMELite
        perlPackages.YAMLTiny
      ]
    }"
    for f in $out/bin/*; do
      test -f $f && wrapProgram $f \
        --prefix PATH : ${dpkg}/bin:${apt}/bin --prefix PERL5LIB : "$perlPath"
    done
  '';

  meta = {
    description = "Tool for building Debian binary packages from Debian sources";
    homepage = "https://salsa.debian.org/debian/sbuild";
    license = lib.licenses.gpl2Plus;
    mainProgram = "sbuild";
  };
})
