{
  lib,
  glibc,
  runCommand,
  autoPatchelfHook,
  stdenv,
  requireFile,
  xar,
  cpio,
  dpkg,
  openssl,
  linux-pam,
}:
let
  sources-tar = requireFile {
    name = "command-monitor_10.13.0-26.ubuntu24_amd64.tar.gz";
    url = "https://www.dell.com/support/kbdoc/en-us/000177080/dell-command-monitor";
    hash = "sha256-Ee6Hh/UEaBBuwjDwHHoApo5kps4ORXMHxa2GgSkltYA=";
  };

  sources = runCommand "unpack-source" { } ''
    mkdir -p $out
    tar -xzf ${sources-tar} -C $out
  '';

  command-monitor = stdenv.mkDerivation (finalAttrs: {
    pname = "dell-command-monitor";
    version = "10.13.0-26";

    src = "${sources}/command-monitor_${finalAttrs.version}.ubuntu24_amd64.deb";

    nativeBuildInputs = [
      dpkg
    ];

    installPhase = ''
      mkdir -p $out
      mv command-monitor omi srvadmin-hapi $out
    '';
  });

  omi = stdenv.mkDerivation (finalAttrs: {
    pname = "omi";
    version = "1.9.1-0";

    src = "${sources}/omi-${finalAttrs.version}.ssl_300.ulinux.s.x64.deb";

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];

    propagatedBuildInputs = [
      openssl
      linux-pam
      glibc
      stdenv.cc.cc.libgcc
      stdenv.cc.cc
    ];

    installPhase = ''
      mkdir $out
      cp -r opt/omi/{bin,lib} $out
      cp -r etc $out
    '';
  });

  srvadmin-hapi = stdenv.mkDerivation (finalAttrs: {
    pname = "srvadmin-hapi";
    version = "9.5.0";

    src = "${sources}/srvadmin-hapi_${finalAttrs.version}_amd64.deb";

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];

    propagatedBuildInputs = [
      # openssl
      # linux-pam
      # glibc
      # stdenv.cc.cc.libgcc
      # stdenv.cc.cc
    ];

    buildPhase = ''
      chmod +x opt/dell/srvadmin/lib64/*.so.${finalAttrs.version}
    '';

    installPhase = ''
      mkdir $out
      cp -r * $out
    '';

    meta = {
      description = "Dell Command | Monitor hardware monitoring agent";
      homepage = "https://www.dell.com/support/kbdoc/en-us/000177080/dell-command-monitor";
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      maintainers = [ lib.maintainers.skyesoss ];
    };
  });
in
srvadmin-hapi
