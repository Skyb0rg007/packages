{
  bpftools,
  fetchFromGitLab,
  lib,
  libbpf,
  linuxHeaders,
  llvmPackages_20,
  networkmanager,
  runCommand,
  stdenv,
}: let
  # Headers needed for compiling eBPF,
  # that aren't included with the linuxHeaders package
  bpf-headers = runCommand "bpf-headers" {} ''
    mkdir -p $out/include/sys
    cat > $out/include/sys/socket.h <<EOF
    #pragma once
    typedef unsigned short int sa_family_t;
    struct sockaddr {
      sa_family_t sa_family;
      char        sa_data[];
    };
    EOF
    cat > $out/include/stdbool.h <<EOF
    #pragma once
    #define bool _Bool
    #define true 1
    #define false 0
    EOF
  '';
in
  networkmanager.overrideAttrs (finalAttrs: prevAttrs:
    prevAttrs
    // {
      src = fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        repo = "NetworkManager";
        owner = "Mstrodl";
        rev = "feature/mstrodl/clat";
        hash = "sha256-V890A9I9MoYjEYB3mSWf84Uh1k6Ne6s+1HzP6BMkh/s=";
      };

      buildInputs = prevAttrs.buildInputs ++ [libbpf];
      nativeBuildInputs =
        prevAttrs.nativeBuildInputs
        ++ [
          llvmPackages_20.clang-unwrapped
          bpftools
          linuxHeaders
        ];

      postPatch = ''
        ${prevAttrs.postPatch}
        substituteInPlace src/core/bpf/meson.build \
          --replace-fail \
            "bpf_o_unstripped_cmd += ['-I.']" \
            "bpf_o_unstripped_cmd += ['-I.', '-I${stdenv.cc.libc.linuxHeaders}/include', '-I${bpf-headers}/include']"
      '';
    })
