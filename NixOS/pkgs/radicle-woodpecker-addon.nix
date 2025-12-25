{
  lib,
  fetchFromRadicle,
  buildGoModule,
}:
buildGoModule {
  pname = "radicle-woodpecker-addon";
  version = "0.1";
  src = fetchFromRadicle {
    seed = "seed.radicle.gr";
    repo = "z39Cf1XzrvCLRZZJRUZnx9D1fj5ws";
    rev = "650ded0ef47c1caee6b9cb6b8aebac4f588985e5";
    hash = "sha256-uqfoIIV7sTRwZH7JOARF1CjGsJ6inolZVLz2SIBZ8qU=";
  };
  vendorHash = "sha256-IfUmxh5McnGpERC+SwnzSyEfhjQuaMKCdQx4mLNdFS0=";

  doCheck = false;

  meta = {
    description = "A radicle forge addon for Woodpecker CI";
    homepage = "https://explorer.radicle.gr/nodes/seed.radicle.gr/rad:z39Cf1XzrvCLRZZJRUZnx9D1fj5ws";
    license = lib.licenses.asl20;
    mainProgram = "radicle-woodpecker-addon";
  };
}
