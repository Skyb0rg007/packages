{
  name = "example";
  meta = {
  };

  nodes.machine = { ... }: { };

  testScript = ''
    machine.start(allow_reboot = True)
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    with subtest("Create user"):
      machine.succeed("useradd -m alice")
      machine.succeed("(echo foobar; echo foobar) | passwd alice")
  '';
}
