FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

BRANCH = "perf_opt"
SRCREV = "f1b45efba788f46fcd361429162031d44488a9ee"
LINUX_VERSION = "4.14.35"

SRC_URI = " \
    git://github.com/xen-troops/linux.git;branch=${BRANCH} \
    file://defconfig \
  "
do_deploy_append () {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}
