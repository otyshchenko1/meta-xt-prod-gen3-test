FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
require inc/xt_shared_env.inc

PVRKM_URL = "git://git@gitpct.epam.com/epmd-aepr/pvr_km_vgpu_img.git"
BRANCH = "1.10/ED5187610_3.21.0"
SRCREV = "50d485a7af5d1c547bf3d25864982a414767f1ef"

# W/A fix build errors with GCC 8.1
SRC_URI_append = " file://0001-Silenced-Wcast-function-type-Wsizeof-pointer-div-and.patch"
