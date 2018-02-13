DEPENDS += " gles-module-egl-headers"

EXTRA_OEMAKE_remove = "LLVM_BUILD_DIR=${STAGING_LIBDIR}/llvm_build_dir"

DEPENDS_remove = "llvmpvr"

PROVIDES_remove = "virtual/opencl libopencl"
RPROVIDES_${PN}_remove = "libopencl"
