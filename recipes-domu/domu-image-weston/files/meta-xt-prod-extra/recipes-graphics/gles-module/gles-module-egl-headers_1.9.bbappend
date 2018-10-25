FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

BRANCH = "perf_opt"
SRCREV = "0cc9f49e294be2c02f8a187b6eb78be989eafd4a"

SRC_URI_append = " \
    file://0001-EGL-eglext.h-Include-eglmesaext.h.patch \
    file://GLES-gl3ext.h.patch \
"

do_install_append() {
    install -d ${DEPLOY_DIR_IMAGE}/xt-rcar
    cp -rf ${D}/* ${DEPLOY_DIR_IMAGE}/xt-rcar
}
