require inc/xt_shared_env.inc

BRANCH = "1.9/4757649-m3n"
SRCREV = "${AUTOREV}"

EXTRA_OEMAKE += "PVRSRV_VZ_NUM_OSID=${XT_PVR_NUM_OSID}"

do_install_append() {
    sed -i 's!soc/!!' ${D}/etc/udev/rules.d/72-pvr-seat.rules
}
