{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  btrfs-progs,
  gpgme,
  libvirt,
  libxcrypt,
  linuxHeaders,
  krb5,
  pkg-config,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "image-builder";
  version = "72.0.0";

  src = fetchFromGitHub {
    owner = "osbuild";
    repo = "image-builder";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6J98FQxRNFCKntr2YuR79HWMxJ9GfaHzZ9QWv656Wi0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    btrfs-progs
    gpgme
    libxcrypt
    libvirt
    linuxHeaders
    krb5
  ];

  vendorHash = "sha256-Z81KACDK6XFhJ0hfUW6l3iSgPOcrZR7I2HE8ChbNOKg=";

  doCheck = false;

  # postPatch = ''
  #   substituteInPlace internal/testutil/testutil.go \
  #     --replace-fail '#!/bin/bash' "#!${stdenv.shell}"
  # '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools to build and deploy disk-images";
    mainProgram = "image-builder";
    homepage = "https://osbuild.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
