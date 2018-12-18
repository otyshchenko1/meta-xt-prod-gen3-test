FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "perf_opt"
SRCREV = "f1b45efba788f46fcd361429162031d44488a9ee"
LINUX_VERSION = "4.14.35"
SRC_URI_append = " \
    file://defconfig \
"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMU}"

do_deploy_append() {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

