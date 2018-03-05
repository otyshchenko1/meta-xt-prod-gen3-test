################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "v0.1.4"

SRC_URI_append_rcar = " git://github.com/xen-troops/displ_be.git;protocol=https"

DEPENDS += " wayland-ivi-extension"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_DRM=ON -DWITH_ZCOPY=ON -DWITH_WAYLAND=ON -DWITH_IVI_EXTENSION=ON -DWITH_INPUT=ON"
