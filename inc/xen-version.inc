
################################################################################
# Following inc file defines XEN version and needed glue info to get it
# built with the current yocto version
################################################################################
require ../meta-xt-images-domx/recipes-extended/xen/xen-4.13-thud.inc

SRC_URI = "git://github.com/xen-troops/xen.git;protocol=https;branch=xen-4.13rc-migration"
SRCREV = "794cf8d2a11920d66af5c104bc8b0f49dd987c59"
