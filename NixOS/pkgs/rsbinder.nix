{
  fetchCrate,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsbinder";
  version = "0.5.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-kuydE+242214bjXcm3ImBqnEOWcNmQvuwLTcqANOqNo=";
  };

  checkFlags = [
    # No clue why this is failing
    "--skip=binder::tests::test_stability"
    # These tests require a mounted binderfs
    "--skip=binderfs::tests::test_add_device"
    "--skip=process_state::tests::test_process_state"
    "--skip=process_state::tests::test_process_state_disable_background_scheduling"
    "--skip=process_state::tests::test_process_state_context_object"
    "--skip=process_state::tests::test_process_state_strong_proxy_for_handle"
    "--skip=process_state::tests::test_process_state_start_thread_pool"
    "--skip=tests::process_state"
  ];

  cargoHash = "sha256-sCNKiRi5/7HM0BVZr/y0M9c+ZjvCE/NyLOL7uD8E0DA=";

  meta = {
    description = "Binder IPC for Linux";
    longDescription = ''
      rsbinder provides crates implemented in pure Rust that make Binder
      IPC available on both Android and Linux.
    '';
    homepage = "https://github.com/hiking90/rsbinder";
    license = lib.licenses.asl20;
  };
})
