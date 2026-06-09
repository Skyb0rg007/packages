{
  lib,
  nixpkgs,
}:

nixpkgs.openvino.overrideAttrs (oldAttrs: {
  cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
    (lib.cmakeFeature "OV_CPACK_LIBRARYDIR" "lib")
    (lib.cmakeFeature "OV_CPACK_RUNTIMEDIR" "lib")
    (lib.cmakeFeature "OV_CPACK_ARCHIVEDIR" "lib")
    (lib.cmakeFeature "OV_CPACK_INCLUDEDIR" "include")
    (lib.cmakeFeature "OV_CPACK_OPENVINO_CMAKEDIR" "lib/cmake/OpenVINO")
    (lib.cmakeFeature "OV_CPACK_PYTHONDIR" "python")
    (lib.cmakeFeature "OV_CPACK_PLUGINSDIR" "lib")
  ];
})
