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
  pkg-config,
}:
buildGoModule (finalAttrs: {
  pname = "image-builder";
  version = "51";

  src = fetchFromGitHub {
    owner = "osbuild";
    repo = "image-builder-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WyXWw/fTMPV4tI4MZAQjZSU7vnHxpx1VEfrvjMWu2jw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    btrfs-progs
    gpgme
    libxcrypt
    libvirt
    linuxHeaders
  ];

  vendorHash = "sha256-arF5LCkWwzYLFXn7l9oEG8ulRHYbOjttQnDYsWY3Ss0=";

  postPatch = ''
    substituteInPlace internal/testutil/testutil.go \
      --replace-fail '#!/bin/bash' "#!${stdenv.shell}"
  '';

  meta = {
    description = "Tools to build and deploy disk-images";
    mainProgram = "image-builder";
    homepage = "https://osbuild.org";
    license = lib.licenses.asl20;
  };
})
