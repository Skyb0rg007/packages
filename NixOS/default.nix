{
  pkgs ? import <nixpkgs> { },
  ...
}:
rec {
  sbuild = pkgs.callPackage ./pkgs/sbuild.nix { };
  keylime = pkgs.callPackage ./pkgs/keylime.nix { };
  rust-keylime = pkgs.callPackage ./pkgs/rust-keylime.nix { };
  # rsbinder = pkgs.callPackage ./pkgs/rsbinder.nix { };
  rsbinder-aidl = pkgs.callPackage ./pkgs/rsbinder-aidl.nix { };
  rsbinder-tools = pkgs.callPackage ./pkgs/rsbinder-tools.nix { };
  brush-HEAD = pkgs.callPackage ./pkgs/brush.nix { };
  run0-wrappers = pkgs.callPackage ./pkgs/run0-wrappers.nix { };
  masque-go = pkgs.callPackage ./pkgs/masque-go.nix { };
  flux9s = pkgs.callPackage ./pkgs/flux9s.nix { };
  image-builder = pkgs.callPackage ./pkgs/image-builder.nix { };

  # Radicle
  radicle-ci-ambient = pkgs.callPackage ./pkgs/radicle-ci-ambient.nix { };
  radicle-woodpecker-addon = pkgs.callPackage ./pkgs/radicle-woodpecker-addon.nix { };

  # Lars Wirzenius's Packages
  ambient-build-vm = pkgs.callPackage ./pkgs/ambient-build-vm.nix { };
  ambient-ci = pkgs.callPackage ./pkgs/ambient-ci.nix { };
  subplot = pkgs.callPackage ./pkgs/subplot.nix { };
  vmdb2 = pkgs.callPackage ./pkgs/vmdb2.nix { };

  anemoi = pkgs.callPackage ./pkgs/anemoi.nix { };
  # archivebox = pkgs.callPackage ./pkgs/archivebox.nix {
  #   python3Packages =
  #     (pkgs.python314Packages.python.override {
  #       packageOverrides = self: super: {
  #         django = self.django_6;
  #         django_6 = self.callPackage ./pkgs/pythonPackages/django_6.nix { };
  #         base32-crockford = self.callPackage ./pkgs/pythonPackages/base32-crockford.nix { };
  #         python-statemachine = self.callPackage ./pkgs/pythonPackages/python-statemachine.nix { };
  #         sonic-client = self.callPackage ./pkgs/pythonPackages/sonic-client.nix { };
  #         abx-pkg = self.callPackage ./pkgs/pythonPackages/abx-pkg.nix { };
  #         django-object-actions = self.callPackage ./pkgs/pythonPackages/django-object-actions.nix { };
  #         django-settings-holder = self.callPackage ./pkgs/pythonPackages/django-settings-holder.nix { };
  #         django-admin-data-views = self.callPackage ./pkgs/pythonPackages/django-admin-data-views.nix { };
  #         django-signal-webhooks = self.callPackage ./pkgs/pythonPackages/django-signal-webhooks.nix { };
  #         django-extensions = super.django-extensions.overrideAttrs {
  #           dontUsePytestCheck = true;
  #         };
  #         txaio = super.txaio.overrideAttrs (prevAttrs: {
  #           disabledTests = prevAttrs.disabledTests ++ [
  #             "test_is_called"
  #             "test_is_future_generic"
  #             "test_gather_no_consume"
  #             "test_gather_two"
  #             "test_create_result"
  #             "test_create_error"
  #           ];
  #         });
  #         daphne = super.daphne.overrideAttrs (prevAttrs: {
  #           doCheck = false;
  #           dontUsePytestCheck = true;
  #         });
  #         autobahn = super.autobahn.overrideAttrs (prevAttrs: {
  #           doCheck = false;
  #           dontUsePytestCheck = true;
  #         });
  #       };
  #     }).pkgs;
  # };
  ascsaver = pkgs.callPackage ./pkgs/ascsaver.nix { };
  mlkit = pkgs.callPackage ./pkgs/mlkit.nix { };
  barry = pkgs.callPackage ./pkgs/barry.nix { inherit mlkit; };
  smltojs = pkgs.callPackage ./pkgs/smltojs.nix { };
  bencher = pkgs.callPackage ./pkgs/bencher.nix { };
  browsertrix-crawler = pkgs.callPackage ./pkgs/browsertrix-crawler.nix { };
  cdash = pkgs.callPackage ./pkgs/cdash.nix { };
  paperless-ai = pkgs.callPackage ./pkgs/paperless-ai.nix { };
  porkbun-ddns = pkgs.callPackage ./pkgs/porkbun-ddns.nix { };
  reddio = pkgs.callPackage ./pkgs/reddio.nix { };
  romm = pkgs.callPackage ./pkgs/romm.nix { };
  tmux-notify = pkgs.callPackage ./pkgs/tmux-notify.nix { };
  tubearchivist = pkgs.callPackage ./pkgs/tubearchivist.nix { };

  pythonPackages = rec {
    python-statemachine =
      pkgs.python3Packages.callPackage ./pkgs/pythonPackages/python-statemachine.nix
        { };
    sonic-client = pkgs.python3Packages.callPackage ./pkgs/pythonPackages/sonic-client.nix { };
    abx-pkg = pkgs.python3Packages.callPackage ./pkgs/pythonPackages/abx-pkg.nix { };
    base32-crockford = pkgs.python3Packages.callPackage ./pkgs/pythonPackages/base32-crockford.nix { };
    django_6 = pkgs.python3Packages.callPackage ./pkgs/pythonPackages/django_6.nix { };
    django-object-actions =
      pkgs.python3Packages.callPackage ./pkgs/pythonPackages/django-object-actions.nix
        { };
    django-settings-holder =
      pkgs.python3Packages.callPackage ./pkgs/pythonPackages/django-settings-holder.nix
        { };
    django-admin-data-views =
      pkgs.python3Packages.callPackage ./pkgs/pythonPackages/django-admin-data-views.nix
        {
          inherit django-settings-holder;
        };
    django-signal-webhooks =
      pkgs.python3Packages.callPackage ./pkgs/pythonPackages/django-signal-webhooks.nix
        {
          inherit django-settings-holder;
        };
  };
}
