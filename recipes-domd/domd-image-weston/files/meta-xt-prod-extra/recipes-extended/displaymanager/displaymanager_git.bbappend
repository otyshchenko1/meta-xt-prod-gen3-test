SRCREV = "${AUTOREV}"

SRC_URI_append = " git://github.com/xen-troops/DisplayManager.git;protocol=https;branch=master"

RDEPENDS_${PN} += " dbus-cxx"

EXTRA_OECMAKE_append = " -DWITH_DOC=OFF -DCMAKE_BUILD_TYPE=Release"
