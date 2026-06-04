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
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "image-builder";
  version = "67";

  src = fetchFromGitHub {
    owner = "osbuild";
    repo = "image-builder-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6LygPo7KdmpKRD7WF0kaEJIFyl5pzJLmNjZEb33pnQ8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    btrfs-progs
    gpgme
    libxcrypt
    libvirt
    linuxHeaders
  ];

  vendorHash = "sha256-0DCUXW4T7ZUGHJCISIvvfZA5b/hdJQt9v24A/8oeyAg=";

  postPatch = ''
    substituteInPlace internal/testutil/testutil.go \
      --replace-fail '#!/bin/bash' "#!${stdenv.shell}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools to build and deploy disk-images";
    mainProgram = "image-builder";
    homepage = "https://osbuild.org";
    license = lib.licenses.asl20;
  };
})
