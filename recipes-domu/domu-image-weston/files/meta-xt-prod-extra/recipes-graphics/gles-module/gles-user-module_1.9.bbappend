require inc/xt_shared_env.inc

BRANCH = "perf_opt"
SRCREV = "0cc9f49e294be2c02f8a187b6eb78be989eafd4a"

SRC_URI_remove = " \
    file://gcc6_pvr_um_1.9.patch \
"

EXTRA_OEMAKE += "PVRSRV_VZ_NUM_OSID=${XT_PVR_NUM_OSID}"
DEPENDS += " gles-module-egl-headers wayland-native"
RDEPENDS_${PN} += "python"

do_install_append() {
    sed -i 's/soc/passthrough/g' ${D}/etc/udev/rules.d/72-pvr-seat.rules
    install -d ${DEPLOY_DIR_IMAGE}/xt-rcar
    cp -rf ${D}/* ${DEPLOY_DIR_IMAGE}/xt-rcar
}
