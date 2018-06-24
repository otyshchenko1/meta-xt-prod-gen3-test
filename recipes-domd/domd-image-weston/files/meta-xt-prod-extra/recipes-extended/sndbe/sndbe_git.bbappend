################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "04caf58cecf262c00c21883987b996f733d9ccb5"

SRC_URI_append_rcar = " git://github.com/xen-troops/snd_be.git;protocol=https;branch=master"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_PULSE=ON"

RDEPENDS_${PN} = "libxenbe libconfig pulseaudio-server"
