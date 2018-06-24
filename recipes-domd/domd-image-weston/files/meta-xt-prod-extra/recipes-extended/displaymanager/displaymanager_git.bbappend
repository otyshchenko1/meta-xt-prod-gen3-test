SRCREV = "6cbf0acec5d33a3be683e48a9cd4be4d16275fe5"

SRC_URI_append = " git://github.com/xen-troops/DisplayManager.git;protocol=https;branch=master"

RDEPENDS_${PN} += " dbus-cpp"

EXTRA_OECMAKE_append = " -DWITH_DOC=OFF -DCMAKE_BUILD_TYPE=Release"
