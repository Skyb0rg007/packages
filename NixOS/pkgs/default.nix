{
  pkgs ? import <nixpkgs> { },
  ...
}:
rec {
  sbuild = pkgs.callPackage ./sbuild.nix { };
  keylime = pkgs.callPackage ./keylime.nix { };
  rust-keylime = pkgs.callPackage ./rust-keylime.nix { };
  # rsbinder = pkgs.callPackage ./rsbinder.nix { };
  rsbinder-aidl = pkgs.callPackage ./rsbinder-aidl.nix { };
  rsbinder-tools = pkgs.callPackage ./rsbinder-tools.nix { };
  brush-HEAD = pkgs.callPackage ./brush.nix { };
  run0-wrappers = pkgs.callPackage ./run0-wrappers.nix { };
  masque-go = pkgs.callPackage ./masque-go.nix { };

  # Radicle
  radicle-ci-ambient = pkgs.callPackage ./radicle-ci-ambient.nix { };
  radicle-woodpecker-addon = pkgs.callPackage ./radicle-woodpecker-addon.nix { };

  # Lars Wirzenius's Packages
  ambient-build-vm = pkgs.callPackage ./ambient-build-vm.nix { };
  ambient-ci = pkgs.callPackage ./ambient-ci.nix { };
  subplot = pkgs.callPackage ./subplot.nix { };
  vmdb2 = pkgs.callPackage ./vmdb2.nix { };

  anemoi = pkgs.callPackage ./anemoi.nix { };
  archivebox = pkgs.callPackage ./archivebox.nix {
    python3Packages =
      (pkgs.python314Packages.python.override {
        packageOverrides = self: super: {
          django = self.django_6;
          django_6 = self.callPackage ./pythonPackages/django_6.nix { };
          base32-crockford = self.callPackage ./pythonPackages/base32-crockford.nix { };
          python-statemachine = self.callPackage ./pythonPackages/python-statemachine.nix { };
          sonic-client = self.callPackage ./pythonPackages/sonic-client.nix { };
          abx-pkg = self.callPackage ./pythonPackages/abx-pkg.nix { };
          django-object-actions = self.callPackage ./pythonPackages/django-object-actions.nix { };
          django-settings-holder = self.callPackage ./pythonPackages/django-settings-holder.nix { };
          django-admin-data-views = self.callPackage ./pythonPackages/django-admin-data-views.nix { };
          django-signal-webhooks = self.callPackage ./pythonPackages/django-signal-webhooks.nix { };
          django-extensions = super.django-extensions.overrideAttrs {
            dontUsePytestCheck = true;
          };
          txaio = super.txaio.overrideAttrs (prevAttrs: {
            disabledTests = prevAttrs.disabledTests ++ [
              "test_is_called"
              "test_is_future_generic"
              "test_gather_no_consume"
              "test_gather_two"
              "test_create_result"
              "test_create_error"
            ];
          });
          daphne = super.daphne.overrideAttrs (prevAttrs: {
            doCheck = false;
            dontUsePytestCheck = true;
          });
          autobahn = super.autobahn.overrideAttrs (prevAttrs: {
            doCheck = false;
            dontUsePytestCheck = true;
          });
        };
      }).pkgs;
  };
  ascsaver = pkgs.callPackage ./ascsaver.nix { };
  barry = pkgs.callPackage ./barry.nix { };
  smltojs = pkgs.callPackage ./smltojs.nix { };
  bencher = pkgs.callPackage ./bencher.nix { };
  browsertrix-crawler = pkgs.callPackage ./browsertrix-crawler.nix { };
  cdash = pkgs.callPackage ./cdash.nix { };
  paperless-ai = pkgs.callPackage ./paperless-ai.nix { };
  porkbun-ddns = pkgs.callPackage ./porkbun-ddns.nix { };
  reddio = pkgs.callPackage ./reddio.nix { };
  romm = pkgs.callPackage ./romm.nix { };
  tmux-notify = pkgs.callPackage ./tmux-notify.nix { };
  tubearchivist = pkgs.callPackage ./tubearchivist.nix { };

  pythonPackages = rec {
    python-statemachine = pkgs.python3Packages.callPackage ./pythonPackages/python-statemachine.nix { };
    sonic-client = pkgs.python3Packages.callPackage ./pythonPackages/sonic-client.nix { };
    abx-pkg = pkgs.python3Packages.callPackage ./pythonPackages/abx-pkg.nix { };
    base32-crockford = pkgs.python3Packages.callPackage ./pythonPackages/base32-crockford.nix { };
    django_6 = pkgs.python3Packages.callPackage ./pythonPackages/django_6.nix { };
    django-object-actions =
      pkgs.python3Packages.callPackage ./pythonPackages/django-object-actions.nix
        { };
    django-settings-holder =
      pkgs.python3Packages.callPackage ./pythonPackages/django-settings-holder.nix
        { };
    django-admin-data-views =
      pkgs.python3Packages.callPackage ./pythonPackages/django-admin-data-views.nix
        {
          inherit django-settings-holder;
        };
    django-signal-webhooks =
      pkgs.python3Packages.callPackage ./pythonPackages/django-signal-webhooks.nix
        {
          inherit django-settings-holder;
        };
  };
}
