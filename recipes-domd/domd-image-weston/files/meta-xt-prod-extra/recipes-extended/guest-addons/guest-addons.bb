SUMMARY = "config files and scripts for a guest"
DESCRIPTION = "config files and scripts for guest which will be running for tests"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = " \
    file://bridge-nfsroot.sh \
    file://bridge.sh \
    file://displbe.service \
    file://bridge-up-notification.service \
    file://eth0.network \
    file://xenbr0.netdev \
    file://xenbr0.network \
    file://xenbr0-systemd-networkd.conf \
    file://port-forward-systemd-networkd.conf \
    file://sndbe.service \
"

S = "${WORKDIR}"

inherit systemd

PACKAGES += " \
    ${PN}-bridge-config \
    ${PN}-displbe-service \
    ${PN}-bridge-up-notification-service \
"

FILES_${PN}-bridge-config = " \
    ${sysconfdir}/systemd/network/eth0.network \
    ${sysconfdir}/systemd/network/xenbr0.netdev \
    ${sysconfdir}/systemd/network/xenbr0.network \
    ${sysconfdir}/systemd/system/systemd-networkd.service.d/xenbr0-systemd-networkd.conf \
    ${sysconfdir}/systemd/system/systemd-networkd.service.d/port-forward-systemd-networkd.conf \
"

SYSTEMD_PACKAGES = " \
    ${PN}-displbe-service \
    ${PN}-bridge-up-notification-service \
"

SYSTEMD_SERVICE_${PN}-displbe-service = " displbe.service"

SYSTEMD_SERVICE_${PN}-bridge-up-notification-service = " bridge-up-notification.service"

FILES_${PN}-displbe-service = " \
    ${systemd_system_unitdir}/displbe.service \
"

FILES_${PN}-bridge-up-notification-service = " \
    ${systemd_system_unitdir}/bridge-up-notification.service \
"
RDEPENDS_${PN}-bridge-config = " \
    ethtool \
"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}
    install -m 0744 ${WORKDIR}/*.sh ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/*.service ${D}${systemd_system_unitdir}

    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/*.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/*.netdev ${D}${sysconfdir}/systemd/network

    install -d ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d
    install -m 0644 ${WORKDIR}/xenbr0-systemd-networkd.conf ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d
    install -m 0644 ${WORKDIR}/port-forward-systemd-networkd.conf ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d

    install -d ${D}${systemd_user_unitdir}
    install -m 0644 ${WORKDIR}/sndbe.service ${D}${systemd_user_unitdir}
    rm -f ${D}${systemd_system_unitdir}/sndbe.service

    install -d ${D}${sysconfdir}/systemd/user/default.target.wants
    ln -sf ${systemd_user_unitdir}/sndbe.service ${D}${sysconfdir}/systemd/user/default.target.wants

}

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}/*.sh \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}/*.cfg \
    ${systemd_user_unitdir}/sndbe.service \
    ${base_prefix}${sysconfdir}/systemd/user/default.target.wants \
"

