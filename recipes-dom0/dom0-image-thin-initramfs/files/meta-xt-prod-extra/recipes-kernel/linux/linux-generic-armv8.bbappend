FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

BRANCH = "perf_opt"
SRCREV = "5c39f22dca28305bc4691313294b606ccb1da10d"
LINUX_VERSION = "4.14.35"

SRC_URI = " \
    git://github.com/xen-troops/linux.git;branch=${BRANCH} \
    file://defconfig \
  "
do_deploy_append () {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}
