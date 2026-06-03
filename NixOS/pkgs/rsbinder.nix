{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsbinder";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "hiking90";
    repo = "rsbinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5VF5Hdn3vL6TJ1Rcu4rC59nLoNEyDXP9p69zrZUnx6c=";
  };

  cargoHash = "sha256-3HK7fDmm0cyGf2Hq2OlOc3rk5QpLsosz9xYIUQ1eCY4=";

  checkFlags = [
    # These tests require a mounted binderfs
    "--skip=test_client::"
    "--skip=test_sm::"
    "--skip=process_state::"
    "--skip=binderfs::tests::test_add_device"
    "--skip=tests::process_state"
    "--skip=thread_state::tests::test_process_pending_derefs_handles_reentrant_push_from_drop"
  ];

  meta = {
    description = "CLI tools for Binder IPC on Linux";
    longDescription = ''
      rsbinder-tools provides two tools:

      rsb_device is a utility for initializing the Linux binder
      environment and creating binder device files.

      rsb_hub is a comprehensive service manager for Linux that replaces
      Android's service_manager functionality.
    '';
    homepage = "https://github.com/hiking90/rsbinder";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
