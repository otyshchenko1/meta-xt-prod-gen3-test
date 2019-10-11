SRCREV = "085bfa86527aa1b43e6193f0ac853ca1335ec003"

SRC_URI_append = " git://github.com/xen-troops/DisplayManager.git;protocol=https;branch=master"

RDEPENDS_${PN} += " dbus-cxx"

EXTRA_OECMAKE_append = " -DWITH_DOC=OFF -DCMAKE_BUILD_TYPE=Release"
