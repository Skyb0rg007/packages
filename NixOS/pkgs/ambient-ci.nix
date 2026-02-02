{
  fetchCrate,
  installShellFiles,
  lib,
  libisoburn,
  qemu,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ambient-ci";
  version = "0.11.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-vgvrinJFNA9K+sjYam/HFpgX3YCLc8EO8VR97D4evbQ=";
  };

  cargoHash = "sha256-d1E1Nzfwmyl/rEaetO1MpGP8EbtaTsaBt2L3BAczHrA=";

  doCheck = !stdenv.buildPlatform.isDarwin;
  nativeCheckInputs = [ libisoburn ];
  nativeBuildInputs = [ installShellFiles ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace src/config.rs \
      --replace-fail /usr/bin/kvm "${lib.getExe' qemu "qemu-kvm"}" \
      --replace-fail "executor: None" "executor: Some(TildePathBuf::new(\"$out/bin/ambient-execute-plan\".into()))"

    runHook postPatch
  '';

  postInstall = ''
    installManPage ambient.1
  '';

  meta = {
    description = "Ambient continuous integration engine";
    longDescription = ''
      Ambient CI is a continuous integration system that aims to make it safe
      and secure to run CI on other people's code.
      It runs all the code from the project under test in a virtual machine
      that has no network access.
    '';
    mainProgram = "ambient";
    homepage = "https://ambient.liw.fi/";
    license = lib.licenses.gpl3Plus;
  };
})
