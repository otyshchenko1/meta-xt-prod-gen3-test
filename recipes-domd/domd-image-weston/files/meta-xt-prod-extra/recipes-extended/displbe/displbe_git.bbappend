################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "6baf227d4af27e1917d275c15c95758611a640b7"

SRC_URI_append_rcar = " git://github.com/xen-troops/displ_be.git;protocol=https;branch=master"

DEPENDS += " wayland-ivi-extension wayland-native"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_DRM=ON -DWITH_ZCOPY=ON -DWITH_WAYLAND=ON -DWITH_IVI_EXTENSION=ON -DWITH_INPUT=ON"
