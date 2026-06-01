{
  fetchCrate,
  lib,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsbinder";
  version = "0.8.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-o4/6rA0QRMmBxlkssXraNagIvVhBvzO7iCMqviUUEic=";
  };

  checkFlags = [
    # These tests require a mounted binderfs
    "--skip=binderfs::tests::test_add_device"
    "--skip=process_state::tests::test_concurrent_strong_proxy_case_b_resurrection"
    "--skip=process_state::tests::test_concurrent_strong_proxy_same_handle_returns_same_arc"
    "--skip=process_state::tests::test_native_dedup_same_arc"
    "--skip=process_state::tests::test_native_distinct_arcs_get_distinct_ids"
    "--skip=process_state::tests::test_native_lookup_does_not_change_counts"
    "--skip=process_state::tests::test_native_uaf_window_closed"
    "--skip=process_state::tests::test_process_state"
    "--skip=process_state::tests::test_process_state_context_object"
    "--skip=process_state::tests::test_process_state_disable_background_scheduling"
    "--skip=process_state::tests::test_process_state_start_thread_pool"
    "--skip=process_state::tests::test_process_state_strong_proxy_for_handle"
    "--skip=process_state::tests::test_strong_proxy_under_same_thread_dead_binder_no_deadlock"
    "--skip=tests::process_state"
    "--skip=thread_state::tests::test_process_pending_derefs_handles_reentrant_push_from_drop"
  ];

  cargoHash = "sha256-4oSLyZ1g43UqhGtMUBPI+jRcUVhdvwsw/VADS86frt0=";

  passthru.updateScript = nix-update-script { };

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
