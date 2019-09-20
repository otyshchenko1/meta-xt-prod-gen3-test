FILESEXTRAPATHS_append := "${THISDIR}/files:"

PR="r2"

SRC_URI_append = " \
    file://system.pa \
    file://daemon.conf \
    file://pulseaudio.service \
"

inherit systemd

INITSCRIPT_PACKAGES = "${PN}-server"
INITSCRIPT_NAME_${PN}-server = "pulseaudio"
INITSCRIPT_PARAMS_${PN}-server = "defaults 30"

SYSTEM_PA = "system.pa"

FILES_${PN}-server += " \
    ${datadir}/alsa/ucm \
    ${datadir}/dbus-1/ \
"

FILES_${PN} = " \
    ${systemd_system_unitdir} \
"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = " pulseaudio.service"

set_cfg_value () {
	sed -i -e "s~\(; *\)\?$2 =.*~$2 = $3~" "$1"
	if ! grep -q "^$2 = $3\$" "$1"; then
		die "Use of sed to set '$2' to '$3' in '$1' failed"
	fi
}

do_install_append () {
    install -d ${D}/etc/pulse

    install -m 0644 ${WORKDIR}/${SYSTEM_PA} ${D}/etc/pulse/system.pa
    install -m 0644 ${WORKDIR}/daemon.conf ${D}/etc/pulse/daemon.conf

    rm -rf ${D}/usr/lib/systemd
    rm ${D}/${sysconfdir}/pulse/default.pa

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/pulseaudio.service ${D}${systemd_system_unitdir}

    set_cfg_value ${D}/${sysconfdir}/pulse/client.conf autospawn no
    set_cfg_value ${D}/${sysconfdir}/pulse/client.conf default-server /var/run/pulse/native
}

