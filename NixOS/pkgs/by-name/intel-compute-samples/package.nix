{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  fetchzip,
  which,
  boost,
  libpng,
  opencl-headers,
  level-zero,
  gtest,
  libva,
  runCommand,
}:
let
  # boost171 = stdenv.mkDerivation {
  #   pname = "boost";
  #   version = "1.71.0";
  #   src = fetchurl {
  #     url = "https://archives.boost.io/release/1.71.0/source/boost_1_71_0.tar.bz2";
  #     sha256 = "d73a8da01e8bf8c7eda40b4c84915071a8c8a0df4a6734537ddde4a8580524ee";
  #   };
  #   nativeBuildInputs = [
  #     boost-build
  #     which
  #   ];
  #
  #   configureScript = "./bootstrap.sh";
  #   configureFlags = [
  #     "--includedir=$(out)/include"
  #     "--libdir=$(out)/include"
  #     "--with-bjam=b2"
  #   ];
  #
  #   buildPhase = ''
  #     runHook preBuild
  #     b2 --includedir=$dev/include \
  #        --libdir=$out/lib \
  #        -j$NIX_BUILD_CORES \
  #        --layout=tagged \
  #        variant=release \
  #        threading=single,multi \
  #        link=shared
  #     runHook postBuild
  #   '';
  #
  #   installPhase = ''
  #     runHook preInstall
  #     b2 --includedir=$dev/include \
  #        --libdir=$out/lib \
  #        -j$NIX_BUILD_CORES \
  #        --layout=tagged \
  #        variant=release \
  #        threading=single,multi \
  #        link=shared \
  #        install
  #     runHook postInstall
  #   '';
  # };
  yuv_samples = fetchzip {
    name = "yuv_samples";
    extension = "tgz";
    url = "https://software.intel.com/file/604709/download";
    hash = "sha256-7b41WJFbEyG6keOabHO4U7WYB0lzihVyGiZ83gFnDLM=";
  };

  mediadata = runCommand "mediadata" { } ''
    mkdir -p $out/yuv
    cp -R ${yuv_samples}/* $out/yuv
  '';
in
stdenv.mkDerivation {
  pname = "intel-compute-samples";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "compute-samples";
    rev = "b18e178ba784e8eff20c2a57314a6df4d9d2f7c1";
    hash = "sha256-3KVXrPZgqCJa4w1teuTcwTQkS21SGDMGghzjVgcELa8=";
  };

  passthru = { inherit mediadata; };

  nativeBuildInputs = [
    cmake
    ninja
    opencl-headers
    gtest
  ];

  buildInputs = [
    boost
    libpng
    level-zero
    libva
  ];

  cmakeFlags = [
    "-DL0_ROOT=${level-zero}"
    "-DMEDIADATA_ROOT=${mediadata}"
  ];

  patchPhase = ''
    sed -i 's/include(import_boost)/find_package(Boost)/' CMakeLists.txt
    sed -i 's/include(import_gtest)/find_package(GTest)/' CMakeLists.txt
    sed -i 's/include(import_opencl)/find_package(OpenCL)/' CMakeLists.txt
  '';

  meta = {
    description = "Sample applications for Intel Compute APIs (OpenCL, Level Zero)";
    homepage = "https://github.com/intel/compute-samples";
    license = lib.licenses.mit;
    broken = true;
    maintainers = [ lib.maintainers.skyesoss ];
  };
}
