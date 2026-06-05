{
  pkgs,
  nixosModules,
  packages,
}:
{
  cascade = pkgs.testers.runNixOSTest {
    imports = [ ./cascade.nix ];
    nodes.machine = {
      imports = [ nixosModules.cascade ];
      services.cascade.package = packages.cascade;
    };
  };
}
