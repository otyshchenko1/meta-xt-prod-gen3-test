################################################################################
# Renesas R-Car
################################################################################
SRC_URI_append_rcar = " git://github.com/xen-troops/snd_be.git;protocol=https;tag=v0.2.0"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_PULSE=ON"
