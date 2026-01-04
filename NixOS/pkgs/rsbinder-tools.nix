{
  fetchCrate,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsbinder-tools";
  version = "0.5.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-MIkpoy1+/ryi/JHuh0J77hHXbjfT4gcY4H9JmhYXzxE=";
  };

  cargoHash = "sha256-NjBu9ZrOiCC2wKqRtjRfIefM+7BOxSMEKOEXs1Gc9vQ=";

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
