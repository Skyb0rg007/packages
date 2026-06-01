{
  fetchCrate,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsbinder-tools";
  version = "0.8.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-g1rI0YbQyIOJR0B3qganKJDjDK2kwEo/LLarejAIQQ8=";
  };

  cargoHash = "sha256-nHSJpZLHaFTiYFUCPQWJg7hOXaSalvGGadzUw+hgtG0=";

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
