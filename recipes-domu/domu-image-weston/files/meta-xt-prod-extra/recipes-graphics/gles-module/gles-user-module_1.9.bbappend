require inc/xt_shared_env.inc

BRANCH = "1.9/4757649-m3n"
SRCREV = "${AUTOREV}"

EXTRA_OEMAKE += "PVRSRV_VZ_NUM_OSID=${XT_PVR_NUM_OSID}"

