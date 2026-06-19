{
  lib,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  avahi,
  zlib,
  openssl,
  gnutls,
  pdfio,
  useOpenSSL ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libcups";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libcups";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ws91j3YfozYn3uP4GqMmsZOwxjDj8aYosOyo6z6MN1o=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    avahi
    pdfio
    zlib
    (if useOpenSSL then openssl else gnutls)
  ];

  meta = {
    homepage = "https://github.com/OpenPrinting/libcups";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
