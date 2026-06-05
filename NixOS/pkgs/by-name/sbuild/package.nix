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
  man-db,
  shadow,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sbuild";
  version = "0.91.9_bpo13+1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "sbuild";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-udehTT9PxqNHOVDWbePfmINkEUn0202urcCT1mSf1W8=";
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
      --replace-quiet /usr/bin/perl ${lib.getExe perl}
    substituteInPlace lib/Buildd.pm \
      --replace-fail /bin/hostname ${lib.getExe hostname}
    substituteInPlace bin/check-old-builds \
      --replace-fail /usr/sbin/sendmail ${lib.getExe system-sendmail}
    substituteInPlace etc/Makefile.am man/Makefile.am \
      --replace-fail PERL5LIB= 'PERL5LIB=$(PERL5LIB):'
    substituteInPlace lib/Sbuild.pm \
      --replace-fail "system('man', '--', \$section, \$page);" \
        "system('${lib.getExe man-db}', \"$out/share/man/man\$section/\$page.\$section.gz\");"
    substituteInPlace lib/Sbuild/ChrootUnshare.pm \
      --replace-fail '/usr/libexec' "$out/libexec" \
      --replace-fail '/usr/sbin/groupadd' '${lib.getExe' shadow "groupadd"}'
  '';

  postInstall = ''
    for h in syscall.h sys/syscall.h sys/ioctl.h sys/ttydefaults.h sys/cdefs.h \
        asm/unistd.h asm/unistd_32.h asm/unistd_64.h bits/wordsize.h \
        bits/syscall.h features.h features-time64.h bits/timesize.h \
        stdc-predef.h gnu/stubs.h gnu/stubs-64.h bits/long-double.h \
        bits/ioctls.h asm/ioctls.h asm-generic/ioctls.h; do
      ${lib.getExe' perl "h2ph"} -d . ${lib.getDev stdenv.cc.libc}/include/$h
      mkdir -p $out/share/perl5/$(dirname $h)
      mv .${lib.getDev stdenv.cc.libc}/include/''${h%.h}.ph $out/share/perl5/$(dirname $h)
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

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = builtins.replaceStrings [ "_" ] [ "~" ] finalAttrs.version;
  };

  meta = {
    description = "Tool for building Debian binary packages from Debian sources";
    homepage = "https://salsa.debian.org/debian/sbuild";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
    mainProgram = "sbuild";
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
