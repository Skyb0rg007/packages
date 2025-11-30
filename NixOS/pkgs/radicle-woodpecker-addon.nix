{
  lib,
  fetchgit,
  buildGoModule,
}:
buildGoModule {
  pname = "radicle-woodpecker-addon";
  version = "0.1";
  src = fetchgit {
    url = "https://seed.radicle.gr/z39Cf1XzrvCLRZZJRUZnx9D1fj5ws.git";
    hash = "sha256-YZJuA9HKGH2LQN9QEMFLfhuXniAxMswyI8UKcc8M/aM=";
  };
  vendorHash = "sha256-IanCM0wf28CvruEAIG2fUPEUguf9Gy66wBHt3x4MCg4=";
  meta = {
    description = "A radicle forge addon for Woodpecker CI";
    homepage = "https://explorer.radicle.gr/nodes/seed.radicle.gr/rad:z39Cf1XzrvCLRZZJRUZnx9D1fj5ws";
    license = lib.licenses.asl20;
    mainProgram = "radicle-woodpecker-addon";
  };
}
